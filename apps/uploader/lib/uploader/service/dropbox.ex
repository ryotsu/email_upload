defmodule Uploader.Service.Dropbox do
  @moduledoc """
  Upload service for dropbox
  """

  @api_url "https://content.dropboxapi.com/2/files/upload"

  def upload_file(file_path, file_name, token) do
    case make_request(file_path, file_name, token) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        handle_success(body)
      {:ok, %HTTPoison.Response{status_code: 401}} ->
        {:error, :unauthorized}
      _ ->
        {:error, :some_error}
    end
  end

  defp make_request(file_path, file_name, token) do
    HTTPoison.post(@api_url, {:file, file_path}, make_headers(file_name, token))
  end

  defp make_headers(file_name, token) do
    [
      {"Authorization", "Bearer #{token}"},
      {"Dropbox-API-Arg", api_arg(file_name)},
      {"Content-Type", "application/octet-stream"}
    ]
  end

  defp api_arg(file_name) do
    %{path: "/#{file_name}", mode: "add", autorename: true, mute: false}
    |> Poison.encode!
  end

  defp handle_success(_body) do
    {:ok, :uploaded}
  end
end
