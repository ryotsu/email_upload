defmodule Webserver.Web.UserController do
  use Webserver.Web, :controller

  alias Webserver.Account
  alias Webserver.Account.User

  plug Ueberauth

  action_fallback Webserver.Web.FallbackController

  def callback(%{assigns: %{ueberauth_failure: _fail}} = _conn, _params) do
    {:error, :authentication_failed}
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case Account.get_user_by(dropbox_uid: auth.uid) do
      nil ->
        user =
          %{"user" => %{
              "firstname" => auth.info.first_name,
              "lastname" => auth.info.last_name,
              "dropbox_uid" => auth.uid,
              "dropbox_token" => auth.credentials.token,
              "namespace" => 20 |> :crypto.strong_rand_bytes() |> Base.encode16
            }
          }
        create(conn, user)

      user ->
        conn
        |> put_status(:ok)
        |> render("show.json", user: user)
    end
  end

  def index(conn, _params) do
    users = Account.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Account.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Account.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Account.get_user!(id)

    with {:ok, %User{} = user} <- Account.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Account.get_user!(id)
    with {:ok, %User{}} <- Account.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
