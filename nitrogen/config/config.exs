# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :nitrogen,
  ecto_repos: [Nitrogen.Repo]

# Configures the endpoint
config :nitrogen, NitrogenWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "bg/Kl7x9BTypnzPMa1S3mf7m8OY4IEH7H+b5e23ElVwbBooH3kD3hSS/RA6+zkOF",
  render_errors: [view: NitrogenWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Nitrogen.PubSub,
  live_view: [signing_salt: "e5+ItgUi"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
