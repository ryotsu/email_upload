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

  # scope "/api", Webserver.Web do
  #   pipe_through :api

  #   resources "/users", UserController, only: [:update, :delete, :show]
  # end
end
