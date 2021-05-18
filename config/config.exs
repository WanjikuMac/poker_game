# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :poker_game,
  ecto_repos: [PokerGame.Repo]

# Configures the endpoint
config :poker_game, PokerGameWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "OXPRv0kUhzSbtnACRBmEaNe05UTr2nSNPHen0KlPR7UtCGYAFoJ023u43WiUThRn",
  render_errors: [view: PokerGameWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: PokerGame.PubSub,
  live_view: [signing_salt: "GPCF0q6T"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
