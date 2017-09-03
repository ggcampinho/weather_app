defmodule WeatherAppWeb.WeatherViewTest do
  use WeatherAppWeb.ConnCase, async: true

  alias WeatherAppWeb.WeatherView
  alias WeatherApp.Weather

  test "returns location with the weather local" do
    location =
      WeatherView.location(%Weather{local: "Berlin", latitude: 52.52, longitude: 13.37})
      |> String.Chars.to_string

    assert location == "Berlin (52.52, 13.37)"
  end

  test "returns location without the weather local" do
    location =
      WeatherView.location(%Weather{local: "", latitude: 52.52, longitude: 13.37})
      |> String.Chars.to_string

    assert location == "Location (52.52, 13.37)"
  end
end
