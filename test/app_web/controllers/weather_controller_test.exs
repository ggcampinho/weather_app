defmodule WeatherAppWeb.PageControllerTest do
  use WeatherAppWeb.ConnCase, async: true, bypass: true

  @tag :bypass
  test "GET /", %{conn: conn, bypass: bypass} do
    Bypass.expect_once(bypass, fn conn ->
      assert conn.method == "GET"
      assert conn.request_path == "/weather"
      assert conn.query_string =~ "appid=test-key"
      assert conn.query_string =~ "units=metric"

      Plug.Conn.resp(conn, 200, ~s"""
      {
        "main": {
          "temp": 25.5,
          "pressure": 1013.75,
          "humidity": 100,
          "temp_min": 21.2,
          "temp_max": 28,
          "sea_level": 1023.22,
          "grnd_level": 1013.75
        }
      }
      """)
    end)

    conn = get conn, "/"
    assert html_response(conn, 200) =~ "25\.5˚C"
  end
end
