defmodule Webserver.Web.Router do
  use Webserver.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Webserver.Web do
    pipe_through :api
  end
end
