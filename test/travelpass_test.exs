defmodule TravelpassTest do
  import Mox
  import Mock
  use ExUnit.Case
  doctest Travelpass

  @api_200_response "{\"consolidated_weather\":[{\"id\":5246488251727872,\"weather_state_name\":\"Clear\",\"weather_state_abbr\":\"c\",\"wind_direction_compass\":\"NW\",\"created\":\"2022-02-06T02:29:16.759493Z\",\"applicable_date\":\"2022-02-05\",\"min_temp\":-4.21,\"max_temp\":5.824999999999999,\"the_temp\":4.8100000000000005,\"wind_speed\":3.6034777140486227,\"wind_direction\":319.7084589236329,\"air_pressure\":1033.0,\"humidity\":54,\"visibility\":13.786673327765847,\"predictability\":68},{\"id\":5846671813509120,\"weather_state_name\":\"Light Cloud\",\"weather_state_abbr\":\"lc\",\"wind_direction_compass\":\"N\",\"created\":\"2022-02-06T02:29:19.676019Z\",\"applicable_date\":\"2022-02-06\",\"min_temp\":-2.6500000000000004,\"max_temp\":3.765,\"the_temp\":5.835,\"wind_speed\":3.178220655730534,\"wind_direction\":9.977878494471968,\"air_pressure\":1034.0,\"humidity\":59,\"visibility\":13.306042710570269,\"predictability\":70},{\"id\":6401787746582528,\"weather_state_name\":\"Light Cloud\",\"weather_state_abbr\":\"lc\",\"wind_direction_compass\":\"SSE\",\"created\":\"2022-02-06T02:29:22.440705Z\",\"applicable_date\":\"2022-02-07\",\"min_temp\":-1.86,\"max_temp\":7.01,\"the_temp\":7.615,\"wind_speed\":3.0486545504626315,\"wind_direction\":153.083880128717,\"air_pressure\":1032.5,\"humidity\":53,\"visibility\":6.242294997216257,\"predictability\":70},{\"id\":5283721860087808,\"weather_state_name\":\"Light Cloud\",\"weather_state_abbr\":\"lc\",\"wind_direction_compass\":\"SSE\",\"created\":\"2022-02-06T02:29:25.242445Z\",\"applicable_date\":\"2022-02-08\",\"min_temp\":0.19500000000000006,\"max_temp\":8.280000000000001,\"the_temp\":8.57,\"wind_speed\":3.146610131238898,\"wind_direction\":150.85709203578674,\"air_pressure\":1030.0,\"humidity\":49,\"visibility\":6.242294997216257,\"predictability\":70},{\"id\":4528343513825280,\"weather_state_name\":\"Heavy Cloud\",\"weather_state_abbr\":\"hc\",\"wind_direction_compass\":\"NW\",\"created\":\"2022-02-06T02:29:28.969774Z\",\"applicable_date\":\"2022-02-09\",\"min_temp\":0.4650000000000001,\"max_temp\":7.415,\"the_temp\":8.065,\"wind_speed\":3.235410163525014,\"wind_direction\":324.15009510967934,\"air_pressure\":1029.0,\"humidity\":55,\"visibility\":6.242294997216257,\"predictability\":71},{\"id\":5940300859047936,\"weather_state_name\":\"Clear\",\"weather_state_abbr\":\"c\",\"wind_direction_compass\":\"W\",\"created\":\"2022-02-06T02:29:31.255064Z\",\"applicable_date\":\"2022-02-10\",\"min_temp\":-0.8350000000000001,\"max_temp\":7.325,\"the_temp\":5.12,\"wind_speed\":1.8733569951483338,\"wind_direction\":261.5,\"air_pressure\":1033.0,\"humidity\":67,\"visibility\":9.999726596675416,\"predictability\":68}],\"time\":\"2022-02-05T21:16:54.882952-07:00\",\"sun_rise\":\"2022-02-05T07:33:20.915635-07:00\",\"sun_set\":\"2022-02-05T17:49:02.664033-07:00\",\"timezone_name\":\"LMT\",\"parent\":{\"title\":\"Utah\",\"location_type\":\"Region / State / Province\",\"woeid\":2347603,\"latt_long\":\"39.499741,-111.547318\"},\"sources\":[{\"title\":\"BBC\",\"slug\":\"bbc\",\"url\":\"http://www.bbc.co.uk/weather/\",\"crawl_rate\":360},{\"title\":\"Forecast.io\",\"slug\":\"forecast-io\",\"url\":\"http://forecast.io/\",\"crawl_rate\":480},{\"title\":\"HAMweather\",\"slug\":\"hamweather\",\"url\":\"http://www.hamweather.com/\",\"crawl_rate\":360},{\"title\":\"Met Office\",\"slug\":\"met-office\",\"url\":\"http://www.metoffice.gov.uk/\",\"crawl_rate\":180},{\"title\":\"OpenWeatherMap\",\"slug\":\"openweathermap\",\"url\":\"http://openweathermap.org/\",\"crawl_rate\":360},{\"title\":\"Weather Underground\",\"slug\":\"wunderground\",\"url\":\"https://www.wunderground.com/?apiref=fc30dc3cd224e19b\",\"crawl_rate\":720},{\"title\":\"World Weather Online\",\"slug\":\"world-weather-online\",\"url\":\"http://www.worldweatheronline.com/\",\"crawl_rate\":360}],\"title\":\"Salt Lake City\",\"location_type\":\"City\",\"woeid\":2487610,\"latt_long\":\"40.759499,-111.888229\",\"timezone\":\"America/Denver\"}"
  

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

  test "200-response on metaweather API" do
    with_mock HTTPoison, [get: fn(_url) -> {:ok, %HTTPoison.Response{status_code: 200, body: @api_200_response}} end] do
      assert Travelpass.weather_request("https://www.metaweather.com/api/location/2487610/") == @api_200_response
    end
  end

  test "404-response on metaweather API" do
    with_mock HTTPoison, [get: fn(_url) -> {:ok, %HTTPoison.Response{status_code: 404}} end] do
      assert Travelpass.weather_request("https://www.metaweather.com/api/location/2487610/") == :ok
    end
  end

  test "Error on metaweather API" do
    with_mock HTTPoison, [get: fn(_url) -> {:error, %HTTPoison.Error{reason: "reason"}} end] do
      assert Travelpass.weather_request("https://www.metaweather.com/api/location/2487610/") == "reason"
    end
  end

  test "Successful return of average temp and cityname from metaweather API" do
    with_mock HTTPoison, [get: fn(_url) -> {:ok, %HTTPoison.Response{status_code: 200, body: @api_200_response}} end] do
      assert Travelpass.get_temp("https://www.metaweather.com/api/location/2487610/") == :ok
    end
  end
end
