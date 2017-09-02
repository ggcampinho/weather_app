# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :app,
  namespace: WeatherApp,
  ecto_repos: [WeatherApp.Repo]

# Configures the endpoint
config :app, WeatherAppWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "EatvA+JmkyWcZTuJB1mzUl1MCykXjUaqFmYlPrYzqxtTR0BVTk4lqBQPDPGMA/FQ",
  render_errors: [view: WeatherAppWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: WeatherApp.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :app, WeatherApp.OpenWeatherMap,
  api_key: System.get_env("OPEN_WEATHER_MAP_API_KEY"),
  base_url: "https://api.openweathermap.org/data/2.5/"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
