defmodule WeatherApp.Weather.Errors.NotFound do
  defexception [:message]

  alias __MODULE__, as: NotFound

  def exception(message) do
    %NotFound{message: message}
  end
end
