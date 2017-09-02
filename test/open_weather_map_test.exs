defmodule WeatherApp.OpenWeatherMapTest do
  use ExUnit.Case, async: true

  alias WeatherApp.OpenWeatherMap, as: OpenWeatherMap
  alias WeatherApp.Weather, as: Weather
  alias WeatherApp.Weather.Temperature, as: Temperature

  setup do
    bypass = Bypass.open
    Application.put_env(:open_weather_map, :base_url, "http://localhost:#{bypass.port}/")
    Application.put_env(:open_weather_map, :api_key, "test-key")

    {:ok, bypass: bypass}
  end

  test "request correct url with app key", %{bypass: bypass} do
    Bypass.expect_once(bypass, fn conn ->
      assert conn.method == "GET"
      assert conn.request_path == "/weather"
      assert conn.query_string == "appid=test-key&latitude=1&longitude=2"

      Plug.Conn.resp(conn, 200, ~s"""
      {
        "main": {
          "temp": 285.514,
          "pressure": 1013.75,
          "humidity": 100,
          "temp_min": 283.2,
          "temp_max": 286.8,
          "sea_level": 1023.22,
          "grnd_level": 1013.75
        }
      }
      """)
    end)

    assert OpenWeatherMap.current_weather(latitude: 1, longitude: 2) ==
      %Weather{temperature: %Temperature{current: 285.514, min: 283.2, max: 286.8}}
  end
end
