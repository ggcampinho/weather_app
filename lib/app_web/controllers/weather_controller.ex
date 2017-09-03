defmodule WeatherAppWeb.WeatherController do
  use WeatherAppWeb, :controller

  alias WeatherApp.Weather

  action_fallback WeatherAppWeb.FallbackController

  def index(conn, _params) do
    with {:ok, weather} <- Weather.current(latitude: random_latitude(), longitude: random_longitude()) do
      render conn, "show.html", weather: weather
    end
  end

  def search(conn, %{"q" => query}) do
    with {:ok, weather} <- Weather.current(city: query) do
      render conn, "show.html", weather: weather
    end
  end

  defp random_latitude do
    ((:rand.uniform() * 180) - 90)
  end

  defp random_longitude do
    ((:rand.uniform() * 360) - 180)
  end
end
