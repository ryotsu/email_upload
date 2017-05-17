defmodule Webserver.Web.Router do
  @moduledoc false

  use Webserver.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/auth", Webserver.Web do
    pipe_through :api

    get "/:provider", UserController, :request
    get "/:provider/callback", UserController, :callback
  end

  scope "/", Webserver.Web do
    pipe_through :api

    post Application.get_env(:mailgun, :hook_url), MailgunController, :webhook
    #resources "/users", UserController, only: [:update, :delete, :show]
  end
end
