defmodule WeatherApp.OpenWeatherMap do
  def current_weather(latitude: latitude, longitude: longitude) do
    build_url("weather")
    |> get(query: build_query(%{lat: latitude, lon: longitude}))
  end

  def current_weather(city: city) do
    build_url("weather")
    |> get(query: build_query(%{q: city}))
  end

  defp get(url, query: query) do
    get(url, query: query, retries: 3)
  end

  defp get(url, query: query, retries: retries) do
    with response <- HTTPotion.get(url, query: query),
         %HTTPotion.Response{status_code: status_code} when status_code < 500 <- response do
      parse_response(response)
    else
      _ when retries > 0 -> get(url, query: query, retries: retries - 1)
      error -> raise "Open Weather Map error: #{error}"
    end
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

  defp parse_response(%HTTPotion.Response{body: body, status_code: 200}) do
    {:ok, :jsx.decode(body, [:return_maps])}
  end

  defp parse_response(%HTTPotion.Response{body: body, status_code: 404}) do
    parsed_body = :jsx.decode(body, [:return_maps])

    {:error, Map.get(parsed_body, "message")}
  end
end
