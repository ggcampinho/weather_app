defmodule WeatherAppWeb.WeatherControllerTest do
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

  @tag :bypass
  test "GET /search", %{conn: conn, bypass: bypass} do
    Bypass.expect_once(bypass, fn conn ->
      assert conn.method == "GET"
      assert conn.request_path == "/weather"
      assert conn.query_string =~ "appid=test-key&q=Berlin&units=metric"

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

    conn = get conn, "/search", %{q: "Berlin"}
    assert html_response(conn, 200) =~ "25\.5˚C"
  end

  @tag :bypass
  test "returns 404 for city not found", %{conn: conn, bypass: bypass} do
    Bypass.expect_once(bypass, fn conn ->
      assert conn.method == "GET"
      assert conn.request_path == "/weather"
      assert conn.query_string =~ "appid=test-key&q=foo&units=metric"

      Plug.Conn.resp(conn, 404, ~s"""
      {
        "cod": "404",
        "message": "city not found"
      }
      """)
    end)

    conn = get conn, "/search", %{q: "foo"}
    assert html_response(conn, 404) =~ "City not found, try to search for something else"
  end
end
