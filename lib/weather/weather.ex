defmodule WeatherApp.Weather do
  defstruct [:temperature]

  alias __MODULE__, as: Weather
  alias WeatherApp.OpenWeatherMap
  alias WeatherApp.Weather.Temperature

  def current(latitude: latitude, longitude: longitude) do
    OpenWeatherMap.current_weather(latitude: latitude, longitude: longitude)
    |> parse_response
  end

  defp parse_response({:ok, body}) do
    %Weather{temperature: parse_temperature(body)}
  end

  defp parse_temperature(%{"main" => %{"temp" => current, "temp_max" => max, "temp_min" => min}}) do
    %Temperature{current: current, max: max, min: min}
  end
end
