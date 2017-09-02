defmodule WeatherApp.OpenWeatherMap do
  alias WeatherApp.Weather, as: Weather
  alias WeatherApp.Weather.Temperature, as: Temperature

  def current_weather(latitude: latitude, longitude: longitude) do
    build_url("weather")
    |> HTTPotion.get(query: build_query(%{latitude: latitude, longitude: longitude}))
    |> parse_response
  end

  defp base_url(), do: Application.fetch_env!(:open_weather_map, :base_url)

  defp build_url(url) do
    base_url() <> url
  end

  defp api_key(), do: Application.fetch_env!(:open_weather_map, :api_key)

  defp build_query(query) do
    Map.put(query, :appid, api_key())
  end

  defp parse_response(%{body: body}) do
    parsed_body = :jsx.decode(body, [:return_maps])

    %Weather{temperature: parse_temperature(parsed_body)}
  end

  defp parse_temperature(%{"main" => %{"temp" => current, "temp_max" => max, "temp_min" => min}}) do
    %Temperature{current: current, max: max, min: min}
  end
end
