defmodule WeatherAppWeb.FallbackController do
  use WeatherAppWeb, :controller

  alias WeatherAppWeb.ErrorView

  def call(conn, {:error, %WeatherApp.Weather.Errors.NotFound{}}) do
    conn
    |> put_status(404)
    |> render(ErrorView, "city_not_found.html")
  end

  def call(conn, _) do
    conn
    |> put_status(500)
    |> render(ErrorView, "500.html")
  end
end
