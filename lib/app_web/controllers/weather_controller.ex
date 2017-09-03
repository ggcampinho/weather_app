defmodule WeatherAppWeb.WeatherController do
  use WeatherAppWeb, :controller

  alias WeatherApp.Weather

  def index(conn, _params) do
    weather = Weather.current(latitude: random_latitude(), longitude: random_longitude())
    render conn, "show.html", weather: weather
  end

  def search(conn, %{"q" => query}) do
    weather = Weather.current(city: query)
    render conn, "show.html", weather: weather
  end

  defp random_latitude do
    ((:rand.uniform() * 180) - 90)
  end

  defp random_longitude do
    ((:rand.uniform() * 360) - 180)
  end
end
