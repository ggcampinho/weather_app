defmodule WeatherAppWeb.WeatherView do
  use WeatherAppWeb, :view

  alias WeatherApp.Weather

  def location(%Weather{local: "", latitude: latitude, longitude: longitude}) do
    ["Location ", geolocation(latitude: latitude, longitude: longitude)]
  end

  def location(%Weather{local: local, latitude: latitude, longitude: longitude}) do
    [local, " ", geolocation(latitude: latitude, longitude: longitude)]
  end

  defp geolocation(latitude: latitude, longitude: longitude) do
    latitude = :erlang.float_to_binary(latitude, [{:decimals, 6}, :compact])
    longitude = :erlang.float_to_binary(longitude, [{:decimals, 6}, :compact])

    ["(", latitude, ", ", longitude, ")"]
  end
end
