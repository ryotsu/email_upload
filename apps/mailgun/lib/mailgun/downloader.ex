defmodule Mailgun.Downloader do
  @moduledoc """
  Module for downloading attachments
  """

  def download(file_path, url) do
    case make_request(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        File.write!(file_path, body)
        :ok
      _ ->
        {:error, :some_error}
    end
  end

  defp make_request(url) do
    options = auth_options()
    HTTPoison.get(url, [], options)
  end

  defp auth_options do
    api_key = Application.get_env(:mailgun, :api_key)
    [hackney: [basic_auth: {"api", api_key}]]
  end
end
