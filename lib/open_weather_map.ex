defmodule WeatherApp.OpenWeatherMap do
  def current_weather(latitude: latitude, longitude: longitude) do
    build_url("weather")
    |> HTTPotion.get(query: build_query(%{lat: latitude, lon: longitude}))
    |> parse_response
  end

  def current_weather(city: city) do
    build_url("weather")
    |> HTTPotion.get(query: build_query(%{q: city}))
    |> parse_response
  end

  defp env(key) do
    Application.fetch_env!(:app, __MODULE__)
    |> Keyword.fetch!(key)
  end

  defp build_url(url) do
    env(:base_url) <> url
  end

  defp build_query(query) do
    query
    |> Map.put(:appid, env(:api_key))
    |> Map.put(:units, :metric)
  end

  defp parse_response(%{body: body, status_code: 200}) do
    {:ok, :jsx.decode(body, [:return_maps])}
  end

  defp parse_response(%{body: body, status_code: 404}) do
    parsed_body = :jsx.decode(body, [:return_maps])

    {:error, Map.get(parsed_body, "message")}
  end
end
