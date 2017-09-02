defmodule WeatherApp.OpenWeatherMap do
  def current_weather(latitude: latitude, longitude: longitude) do
    build_url("weather")
    |> HTTPotion.get(query: build_query(%{latitude: latitude, longitude: longitude}))
    |> parse_response
  end

  defp env(key) do
    Application.fetch_env!(:app, __MODULE__)
    |> Keyword.get(key)
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
end
