defmodule Travelpass do

 
  def return_results do 
    #input your different city locations here
      tasks = for n <- [
        "https://www.metaweather.com/api/location/2487610/",
        "https://www.metaweather.com/api/location/2442047/",
        "https://www.metaweather.com/api/location/2366355/"
      ], 
      #creates multiple processes that run asynchronously 
      do: Task.async(fn -> fetch_weather(n) end )

      #awaits the return of each process 
      Task.await_many(tasks)
       # for t <- tasks, do: Task.await(t)
  end 
  

  
  def fetch_weather(url) do    
 
    %{body: body} = HTTPoison.get! url

    %{consolidated_weather: consolidated_weather} = Poison.decode! body, keys: :atoms
    %{title: city_name} = Poison.decode! body, keys: :atoms
    
      temp_values = Enum.map(consolidated_weather, fn (x) -> x[:max_temp] end)
    
      #calls function to return an average
      temp_average = average(temp_values)

      #calls function to convert Celcius to Fahrenheit
      fahrenheit = convert_to_fahrenheit(temp_average)

      IO.puts("#{city_name} Average Max Temp: #{fahrenheit}")
  end

  #Finds average of List of numbers 
  def average(values) do 
    Enum.sum(values) / Enum.count(values)
  end

  #Converts Celcius to Fahrenheit
  def convert_to_fahrenheit(value) do 
    value * 9/5 + 32
  end

end
