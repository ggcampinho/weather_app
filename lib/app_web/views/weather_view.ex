defmodule WeatherAppWeb.WeatherView do
  use WeatherAppWeb, :view

  alias WeatherApp.Weather
  alias WeatherApp.Weather.Temperature

  def location(%Weather{local: ""}) do
    "Unknown location"
  end

  def location(%Weather{local: local}) do
    local
  end

  def geolocation(%Weather{latitude: latitude, longitude: longitude}) do
    latitude = :erlang.float_to_binary(latitude, [{:decimals, 6}, :compact])
    longitude = :erlang.float_to_binary(longitude, [{:decimals, 6}, :compact])

    ["(", latitude, ", ", longitude, ")"]
  end

  def current_temperature(%Weather{temperature: %Temperature{current: current}}) do
    temperature = :erlang.float_to_binary(current, [{:decimals, 1}, :compact])
    [remove_trailing_zero(temperature), "˚C"]
  end

  defp remove_trailing_zero(number) do
    String.replace_suffix(number, ".0", "")
  end
end
