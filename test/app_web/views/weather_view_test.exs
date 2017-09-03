defmodule WeatherAppWeb.WeatherViewTest do
  use WeatherAppWeb.ConnCase, async: true

  alias WeatherAppWeb.WeatherView
  alias WeatherApp.Weather
  alias WeatherApp.Weather.Temperature

  test "returns location" do
    assert WeatherView.location(%Weather{local: "Berlin", latitude: 52.52, longitude: 13.37}) == "Berlin"

    assert WeatherView.location(%Weather{local: "", latitude: 52.52, longitude: 13.37}) == "Unknown location"
  end

  test "returns geolocation" do
    geolocation =
      WeatherView.geolocation(%Weather{local: "Berlin", latitude: 52.52, longitude: 13.37})
      |> String.Chars.to_string

    assert geolocation == "(52.52, 13.37)"
  end

  test "returns current temperature rounded" do
    temperature =
      WeatherView.current_temperature(%Weather{temperature: %Temperature{current: 25.52}})
      |> String.Chars.to_string

    assert temperature == "25.5˚C"

    temperature =
      WeatherView.current_temperature(%Weather{temperature: %Temperature{current: 25.0}})
      |> String.Chars.to_string

    assert temperature == "25˚C"

    temperature =
      WeatherView.current_temperature(%Weather{temperature: %Temperature{current: 25}})
      |> String.Chars.to_string

    assert temperature == "25˚C"

    temperature =
      WeatherView.current_temperature(%Weather{temperature: %Temperature{current: 25.89}})
      |> String.Chars.to_string

    assert temperature == "25.9˚C"
  end
end
