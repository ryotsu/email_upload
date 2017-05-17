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
  secret_key_base: "c/BtKZSfK74bj92DVU9n2Em1Q3YOVm7w9WVq0UyIe6sUi9n3kuPFSLe568ijUXq7",
  render_errors: [view: Webserver.Web.ErrorView, accepts: ~w(json)],
  pubsub: [name: Webserver.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"