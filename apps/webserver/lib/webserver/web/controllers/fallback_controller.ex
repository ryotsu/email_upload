defmodule Webserver.Web.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use Webserver.Web, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(Webserver.Web.ChangesetView, "error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(Webserver.Web.ErrorView, :"404")
  end

  def call(conn, {:error, :authentication_failed}) do
    conn
    |> put_status(:bad_request)
    |> render(Webserver.Web.ErrorView, :authentication_failed)
  end

  def call(conn, {:error, :parsing_failed, error}) do
    conn
    |> put_status(:not_acceptable)
    |> render(Webserver.Web.ErrorView, "parsing_failed.json", error: error)
  end
end
