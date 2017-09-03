defmodule WeatherApp.ApiCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use ExUnit.Case
    end
  end

  setup tags do
    bypass = if tags[:bypass], do: setup_bypass()
    {:ok, bypass: bypass}
  end

  def setup_bypass do
    bypass = Bypass.open

    Application.put_env(:app, WeatherApp.OpenWeatherMap,
      base_url: "http://localhost:#{bypass.port}/",
      api_key: "test-key")

    bypass
  end
end
