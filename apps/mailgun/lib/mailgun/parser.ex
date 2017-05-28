defmodule Mailgun.Parser do
  @moduledoc """
  Parser for Mailgun mails
  """

  alias Mailgun.Mail
  alias Mailgun.Mail.Attachment

  @spec verify_and_parse(map) :: {:ok, Mail.t} | {:error, String.t}
  def verify_and_parse(request) do
    timestamp = Map.get(request, "timestamp", "")
    token = Map.get(request, "token", "")
    signature = Map.get(request, "signature", "")

    mail_signature =
      :sha256
      |> :crypto.hmac(key(), timestamp <> token)
      |> Base.encode16
      |> String.downcase

    case mail_signature do
      ^signature ->
        parse(request)
      _ ->
        {:error, "Invalid signature"}
    end
  end

  @spec parse(map) :: Mail.t
  defp parse(request) do
    with {:ok, namespace, service} <- name_and_service(request),
         {:ok, attachments} <- get_attachments(request) do
      {:ok, %Mail{
          sender: request["sender"],
          service: service,
          namespace: namespace,
          attachments: attachments,
          timestamp: request["timestamp"] |> String.to_integer
        }
      }
    end
  end

  @spec name_and_service(map) :: {:ok, String.t, atom} | {:error, String.t}
  defp name_and_service(%{"recipient" => addr}) do
    case Regex.run(~r/(.*)@(.*)\.kochika\.me/, addr) do
      [^addr, namespace, "dropbox"] ->
        {:ok, namespace, :dropbox}
      _ ->
        {:error, "Unrecognized service"}
    end
  end

  defp name_and_service(_request), do: {:error, "No name or service"}

  @spec get_attachments(map) :: {:ok, [Attachment.t]}
  defp get_attachments(%{"attachments" => attachments}) do
    parsed_attachments =
      attachments
      |> Poison.decode!
      |> Enum.map(fn attachment ->
      %Attachment{
        name: attachment["name"],
        url: attachment["url"],
        size: attachment["size"],
        content_type: attachment["content-type"]
      }
    end)

    {:ok, parsed_attachments}
  end

  defp get_attachments(_request), do: {:error, "No attachments"}

  defp key do
    Application.get_env(:mailgun, :api_key)
  end
end
