defmodule Uploader.File.Worker do
  @moduledoc false

  @behaviour :gen_statem

  @dir "./files"

  require Logger

  alias Mailgun.Mail.Attachment
  alias Mailgun.Downloader
  alias Uploader.Service.Dropbox

  def start_link(file, token, counter) do
    :gen_statem.start_link(__MODULE__, [file, token, counter], [])
  end

  def callback_mode do
    :state_functions
  end

  def stop(pid) do
    :gen_statem.stop(pid)
  end

  def init([file, token, counter]) do
    Uploader.File.Manager.add_child(counter)
    {:ok, :prep, {file, token, counter}, 0}
  end

  def prep(:timeout, 0, {file, token, counter}) do
    file_name = 20 |> :crypto.strong_rand_bytes |> Base.encode16
    download_path = Path.join(@dir, file_name)
    file = %Attachment{file | download_path: download_path}

    {:next_state, :download, {file, token, counter}, 0}
  end

  def download(:timeout, 0, {file, token, counter}) do
    case Downloader.download(file.download_path, file.url) do
      :ok ->
        file = %Attachment{file | downloaded?: true}
        {:next_state, :upload, {file, token, counter}, 0}
      {:error, _} ->
        Logger.warn "Some error occurred while downloading"
        {:stop, :normal}
    end
  end

  def upload(:timeout, 0, {file, token, _counter}) do
    case Dropbox.upload_file(file.download_path, file.name, token) do
      {:ok, :uploaded} ->
        {:stop, :normal}
      {:error, _} ->
        Logger.warn "Some error occurred while uploading"
        {:stop, :normal}
    end
  end

  def terminate(_reason, _state, {file, _token, counter}) do
    File.rm(file.download_path)
    Uploader.File.Manager.remove_child(counter)
    :ok
  end

  def code_change(_vsn, _state, _data, _extra) do
    {:ok, :keep_state_and_data}
  end

  def handle_event(_event, _content, _data) do
    {:keep_state_and_data}
  end
end
