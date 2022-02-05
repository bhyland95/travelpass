defmodule Travelpass do
   @moduledoc """
  Provides a function `return_results/0` that asynchronously returns a six-day average in Fahrenheit of one or more city's maximum temperatures. 
  """

  def return_results do 
    
      tasks = for n <- [
        "https://www.metaweather.com/api/location/2487610/",
        "https://www.metaweather.com/api/location/2442047/",
        "https://www.metaweather.com/api/location/2366355/"
      ], 
     
      do: Task.async(fn -> fetch_weather(n) end )

     
      Task.await_many(tasks)
  end 
  
  def fetch_weather(url) do    
    
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        
        %{consolidated_weather: consolidated_weather, title: city_name} = Poison.decode! body, keys: :atoms
        temp = Enum.map(consolidated_weather, fn (x) -> x[:max_temp] end)
          |>  average()
          |>  convert_to_fahrenheit()

        IO.puts("#{city_name} Average Max Temp: #{temp}")
          
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Location Not found "

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

  @doc """
  Finds the average of numerical values in a list.

  ## Parameters

    - values: List containing integers or numbers

  ## Examples

      iex> Travelpass.average([1,2,3])
      2

      iex> Travelpass.average([5.5, 9, 12.25])
      8.92

  """
  @spec average([number]) :: number
  def average(values) do 
    (Enum.sum(values) / Enum.count(values))
      |> Float.ceil(2)
  end

@doc """
  Converts a temperature in Celcius to a temperature in Fahrenheit

  ## Parameters

    - value: An integer or number 

  ## Examples

      iex> Travelpass.convert_to_fahrenheit(0)
      32

      iex> Travelpass.convert_to_fahrenheit(12.67)
      54.81

  """
  @spec convert_to_fahrenheit(number) :: number
  def convert_to_fahrenheit(value) do 
    value * 9/5 + 32 
      |> Float.ceil(2)
  end

end
