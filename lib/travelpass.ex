defmodule Travelpass do
   @moduledoc """
  Provides a function `return_results/0` that asynchronously returns a six-day average in Fahrenheit of one or more city's maximum temperatures. 
  """

  @doc """
  Asynchronously runs calls to the metaweather api for all the URLs contained in 'tasks' variable. 
  It will await for all the URLS in 'tasks' to finish before moving on. 
  """
  def return_results do 
      # Add URLs with the location ID here to see the average temp for the specified location
      tasks = for n <- [
        "https://www.metaweather.com/api/location/2487610/",
        "https://www.metaweather.com/api/location/2442047/",
        "https://www.metaweather.com/api/location/2366355/"
      ], 
     
      do: Task.async(fn -> get_temp(n) end )
     
      Task.await_many(tasks)
  end 


  @doc """
  Makes a request to the metaweather API and returns the data if the status code is 200.

  ## Parameters

    - url: A String of the URL from the metaweather API with the location ID attached.
  """
  def weather_request(url) do    
    case  HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Location not found"
        
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end
  @doc """
  Calls the 'weather_request' function and decodes the data. 
  This function grabs the max_temp for each day of the 6-day forecast of a city as well as the city name.
  It then averages the temperatures, converts the new temperature from Celcius to Fahrenheit, 
  and returns a string stating the average temperature for the city. 

  ## Parameters

    - url: A String of the URL from the metaweather API with the location ID attached. 
  """
  def get_temp(url) do 
    body = weather_request(url)
    
    %{consolidated_weather: weather, title: city_name} = Poison.decode! body, keys: :atoms
         temp = Enum.map(weather, fn (x) -> x[:max_temp] end)
          |>  average()
          |>  convert_to_fahrenheit()

        IO.puts("#{city_name} Average Max Temp: #{temp}")
  end
  
  @doc """
  Finds the average of numerical values in a list.

  ## Parameters

    - values: List containing integers or numbers

  """
  def average(values) do 
    (Enum.sum(values) / Enum.count(values))
      |> Float.ceil(2)
  end

@doc """
  Converts a temperature in Celcius to a temperature in Fahrenheit

  ## Parameters

    - value: An integer or number 

  """
  def convert_to_fahrenheit(value) do 
    value * 9/5 + 32 
      |> Float.ceil(2)
  end
end
