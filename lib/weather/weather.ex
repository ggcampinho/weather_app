defmodule WeatherApp.Weather do
  defstruct [:temperature]

  alias __MODULE__, as: Weather
  alias WeatherApp.OpenWeatherMap
  alias WeatherApp.Weather.Temperature
  alias WeatherApp.Weather.Errors.NotFound

  def current(args) do
    OpenWeatherMap.current_weather(args)
    |> parse_response
  end

  defp parse_response({:ok, body}) do
    {:ok, %Weather{temperature: parse_temperature(body)}}
  end

  defp parse_response({:error, reason = "city not found"}) do
    {:error, NotFound.exception(reason)}
  end

  defp parse_temperature(%{"main" => %{"temp" => current, "temp_max" => max, "temp_min" => min}}) do
    %Temperature{current: current, max: max, min: min}
  end
end
