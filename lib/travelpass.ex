defmodule Travelpass do

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

  
  def average(values) do 
    (Enum.sum(values) / Enum.count(values))
      |> Float.ceil(2)
  end


  def convert_to_fahrenheit(value) do 
    value * 9/5 + 32 
      |> Float.ceil(2)
  end

end
