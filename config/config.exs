# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :hobby_stocks,
  ecto_repos: [HobbyStocks.Repo],
  tiingo_token: "cdb1e5f1ab90210894b2990fa2d5576901b589ba"

config :hobby_stocks, HobbyStocks.Repo,
  port: System.get_env("PGPORT") || 5432

# Configures the endpoint
config :hobby_stocks, HobbyStocksWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "1Capg8IBVptqfqXjUnXsRc9hglghSmq1Q/rMobcxZ8gK5wS///98yASdIDF8NvbF",
  render_errors: [view: HobbyStocksWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: HobbyStocks.PubSub,
  live_view: [signing_salt: "t/LF0d/H"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
