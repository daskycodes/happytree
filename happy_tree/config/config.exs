# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :happy_tree,
  ecto_repos: [HappyTree.Repo]

# Configures the endpoint
config :happy_tree, HappyTreeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "fok6OU6Y+hwTsliurAj+PmE6yax2OUULqkNJhGnTzDX6/9ghGFvVVljhhdK0bItZ",
  render_errors: [view: HappyTreeWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: HappyTree.PubSub,
  live_view: [signing_salt: "Jtww1M5E"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# https://github.com/rafaeelaudibert/trifolium
config :trifolium,
  token: System.get_env("TREFLE_TOKEN"),
  api_domain: System.get_env("TREFLE_API")

config :happy_tree, :plants_finder, module: HappyTree.PlantsFinder
config :happy_tree, :plants_detector, module: HappyTree.PlantsDetector

# https://github.com/ex-aws/ex_aws
config :ex_aws,
  secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
  access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
  region: "eu-central-1",
  iot_keyfile: System.get_env("AWS_IOT_KEYFILE"),
  iot_certfile: System.get_env("AWS_IOT_CERTFILE"),
  iot_host: 'localhost',
  json_codec: Jason,
  iot_port: 1883,
  iot_transport: Tortoise.Transport.Tcp

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
