# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :webserver,
  namespace: Webserver,
  ecto_repos: [Webserver.Repo]

# Configures the endpoint
config :webserver, Webserver.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  render_errors: [view: Webserver.Web.ErrorView, accepts: ~w(json)],
  pubsub: [name: Webserver.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure Cloak
config :cloak, Cloak.AES.CTR,
  tag: "AES",
  default: true,
  keys: [
    %{tag: <<1>>,
      key: :base64.decode(System.get_env("CLOAK_ENCRYPTION_KEY")  || "6dtj3NCvhrXZs0V7YqP9NA1nVrlfhIWZSRBvMOmAClU="),
      default: true}
  ]

# Ueberauth
config :ueberauth, Ueberauth,
  providers: [
    dropbox: {Ueberauth.Strategy.Dropbox, []},
  ]

config :ueberauth, Ueberauth.Strategy.Dropbox.OAuth,
  client_id: System.get_env("DROPBOX_CLIENT_ID"),
  client_secret: System.get_env("DROPBOX_CLIENT_SECRET")

config :mailgun,
  webhook_url: System.get_env("MAILGUN_WEBHOOK_URL") || "/webhook"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
