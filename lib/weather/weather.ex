defmodule WeatherApp.Weather do
  defstruct [:local, :latitude, :longitude, :temperature]

  alias __MODULE__, as: Weather
  alias WeatherApp.OpenWeatherMap
  alias WeatherApp.Weather.Temperature
  alias WeatherApp.Weather.Errors.NotFound

  def current(args) do
    OpenWeatherMap.current_weather(args)
    |> parse_response
  end

  defp parse_response({:ok, body}) do
    {:ok, parse_weather(body)}
  end

  defp parse_response({:error, reason = "city not found"}) do
    {:error, NotFound.exception(reason)}
  end

  defp parse_weather(%{"name" => name, "main" => main, "coord" => %{"lat" => latitude, "lon" => longitude}}) do
     %Weather{
      local: name,
      latitude: latitude,
      longitude: longitude,
      temperature: parse_temperature(main)
    }
  end

  defp parse_temperature(%{"temp" => current, "temp_max" => max, "temp_min" => min}) do
    %Temperature{
      current: current,
      max: max,
      min: min
    }
  end
end
