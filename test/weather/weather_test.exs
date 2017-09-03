defmodule WeatherApp.WeatherTest do
  use WeatherApp.ApiCase, async: true

  alias WeatherApp.Weather
  alias WeatherApp.Weather.Temperature

  @tag :bypass
  test "returns the current weather for a geolocation correctly", %{bypass: bypass} do
    Bypass.expect_once(bypass, fn conn ->
      assert conn.method == "GET"
      assert conn.request_path == "/weather"
      assert conn.query_string == "appid=test-key&lat=1&lon=2&units=metric"

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

    assert Weather.current(latitude: 1, longitude: 2) ==
      %Weather{temperature: %Temperature{current: 285.514, min: 283.2, max: 286.8}}
  end

  @tag :bypass
  test "returns the current weather for a city correctly", %{bypass: bypass} do
    Bypass.expect_once(bypass, fn conn ->
      assert conn.method == "GET"
      assert conn.request_path == "/weather"
      assert conn.query_string == "appid=test-key&q=Berlin&units=metric"

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

    assert Weather.current(city: "Berlin") ==
      %Weather{temperature: %Temperature{current: 285.514, min: 283.2, max: 286.8}}
  end
end
