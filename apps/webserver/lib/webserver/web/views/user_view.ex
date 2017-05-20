defmodule Webserver.Web.UserView do
  use Webserver.Web, :view
  alias Webserver.Web.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      name: "#{user.firstname} #{user.lastname}",
      email: "#{user.namespace}@dropbox.kochika.me"
    }
  end
end
