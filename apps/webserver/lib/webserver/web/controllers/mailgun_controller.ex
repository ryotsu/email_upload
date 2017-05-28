defmodule Webserver.Web.MailgunController do
  use Webserver.Web, :controller

  alias Webserver.Account
  alias Mailgun.Parser
  alias Mailgun.Mail
  alias Uploader.Queue

  action_fallback Webserver.Web.FallbackController

  def webhook(conn, params) do
    case Parser.verify_and_parse(params) do
      {:ok, mail} ->
        with {:ok, token} <- Account.get_token(mail.namespace, mail.service) do
          new_mail = %Mail{mail | token: token}
          Queue.push(new_mail, new_mail.timestamp)
          conn
          |> put_status(:ok)
          |> render("status.json", status: "success")
        end
      {:error, error} ->
        {:error, :parsing_failed, error}
    end
  end
end
