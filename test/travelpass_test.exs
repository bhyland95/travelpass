defmodule TravelpassTest do
  use ExUnit.Case
  doctest Travelpass

  import Mox

  setup :verify_on_exit!

  test "Celcius is converted to Fahrenheit" do
    assert Travelpass.convert_to_fahrenheit(0) == 32
  end

  test "Celcius is converted to Fahrenheit and rounds up to two decimal places" do
    assert Travelpass.convert_to_fahrenheit(2.34) == 36.22
  end

  test "Gets average of all numbers in a list and rounds up to two decimal places " do
    assert Travelpass.average([5,9,12]) == 8.67
  end


  # test ":ok on 200" do
  #   expect(HTTPoison.BaseMock, :get, fn _ -> {:ok, ""} end)

  #   assert {:ok, _} = Travelpass.fetch_weather("https://www.metaweather.com/api/location/2487610/")
  # end

  # test ":error on 404" do
  #   expect(HTTPoison.BaseMock, :get, fn _ -> {:error, ""} end)
  #   assert {:error, _} = Travelpass.fetch_weather("Location not found")
  # end

 

end
