defmodule TravelpassTest do
  use ExUnit.Case
  doctest Travelpass

  test "Celcius is converted to Fahrenheit" do
    assert Travelpass.convert_to_fahrenheit(0) == 32
  end

  test "Celcius is converted to Fahrenheit and rounds up to two decimal places" do
    assert Travelpass.convert_to_fahrenheit(2.34) == 36.22
  end

  test "Gets average of all numbers in a list and rounds up to two decimal places " do
    assert Travelpass.average([5,9,12]) == 8.67
  end

end
