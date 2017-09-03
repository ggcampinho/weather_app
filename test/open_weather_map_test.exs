defmodule WeatherApp.OpenWeatherMapTest do
  use WeatherApp.ApiCase, async: true

  alias WeatherApp.OpenWeatherMap

  @tag :bypass
  test "returns the current weather correctly", %{bypass: bypass} do
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

    {:ok, body} = OpenWeatherMap.current_weather(latitude: 1, longitude: 2)

    assert body == %{
        "main" => %{
          "temp" => 285.514,
          "pressure" => 1013.75,
          "humidity" => 100,
          "temp_min" => 283.2,
          "temp_max" => 286.8,
          "sea_level" => 1023.22,
          "grnd_level" => 1013.75
        }
      }
  end
end
