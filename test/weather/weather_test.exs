defmodule WeatherApp.WeatherTest do
  use WeatherApp.ApiCase, async: true

  alias WeatherApp.Weather
  alias WeatherApp.Weather.Temperature
  alias WeatherApp.Weather.Errors.NotFound

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
        },
        "name": "Berlin",
        "coord": {
          "lat": 52.52,
          "lon": 13.37
        }
      }
      """)
    end)

    {:ok, weather} = Weather.current(latitude: 1, longitude: 2)

    assert weather == %Weather{
      local: "Berlin",
      latitude: 52.52,
      longitude: 13.37,
      temperature: %Temperature{current: 285.514, min: 283.2, max: 286.8}
    }
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
        },
        "name": "Berlin",
        "coord": {
          "lat": 52.52,
          "lon": 13.37
        }
      }
      """)
    end)

    {:ok, weather} = Weather.current(city: "Berlin")

    assert weather == %Weather{
      local: "Berlin",
      latitude: 52.52,
      longitude: 13.37,
      temperature: %Temperature{current: 285.514, min: 283.2, max: 286.8}
    }
  end

  @tag :bypass
  test "returns error for a city not found", %{bypass: bypass} do
    Bypass.expect_once(bypass, fn conn ->
      assert conn.method == "GET"
      assert conn.request_path == "/weather"
      assert conn.query_string == "appid=test-key&q=foo&units=metric"

      Plug.Conn.resp(conn, 404, ~s"""
      {
        "cod": "404",
        "message": "city not found"
      }
      """)
    end)

    assert Weather.current(city: "foo") == {:error, %NotFound{message: "city not found"}}
  end
end
