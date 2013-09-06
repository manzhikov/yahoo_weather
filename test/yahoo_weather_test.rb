require 'test_helper'
require 'fakeweb'

class YahooWeatherTest < ActiveSupport::TestCase

  def setup
    @client = YahooWeather::Client.new
    @woeid_sf = '12797168'
    @response = @client.fetch(@woeid_sf)
  end

  test 'Fetch by WOEID' do
    _assert_valid_response(@response, @woeid_sf,
                           YahooWeather::Units::FAHRENHEIT,
                           'San Francisco', 'CA', 'United States')
  end

  test 'Fetch with the bad response' do
    client = YahooWeather::Client.new
    woeid_sf = '10001'
    FakeWeb.register_uri(
      :get,
      "http://weather.yahooapis.com/forecastrss?w=#{woeid_sf}&u=f",
      :body => "Nothing to be found 'round here",
      :status => ["404", "Not Found"]
    )
    problem = assert_raise(RuntimeError) {client.fetch(woeid_sf)}
    assert_equal "Failed to get weather. Got a bad status code 404 Not Found", problem.message
    FakeWeb.clean_registry
  end

  test 'Success response' do
    assert_instance_of YahooWeather::Condition, @response.condition
    assert_instance_of YahooWeather::Location, @response.location
    assert_instance_of YahooWeather::Units, @response.units
    assert_instance_of YahooWeather::Astronomy, @response.astronomy
    assert_instance_of YahooWeather::Atmosphere, @response.atmosphere
    assert_instance_of Array, @response.forecasts
  end

  test 'Condition' do
    assert_instance_of YahooWeather::Condition, @response.condition
    _assert_valid_weather_code @response.condition.code
    assert_instance_of Time, @response.condition.date
    assert_kind_of Numeric, @response.condition.temp
    assert(@response.condition.text && @response.condition.text.length > 0)
  end

  test 'Wind' do
    assert_instance_of YahooWeather::Wind, @response.wind
    assert(@response.wind.chill <= @response.condition.temp)
    assert_kind_of Numeric, @response.wind.direction
    assert_kind_of Numeric, @response.wind.speed

    _test_wind_direction(0, 'N')
    _test_wind_direction(12, 'NNE')
    _test_wind_direction(34, 'NE')
    _test_wind_direction(57, 'ENE')
    _test_wind_direction(79, 'E')
    _test_wind_direction(102, 'ESE')
    _test_wind_direction(124, 'SE')
    _test_wind_direction(147, 'SSE')
    _test_wind_direction(169, 'S')
    _test_wind_direction(192, 'SSW')
    _test_wind_direction(214, 'SW')
    _test_wind_direction(237, 'WSW')
    _test_wind_direction(259, 'W')
    _test_wind_direction(282, 'WNW')
    _test_wind_direction(304, 'NW')
    _test_wind_direction(327, 'NNW')
    _test_wind_direction(349, 'N')
  end

  test 'Astronomy' do
    assert_instance_of YahooWeather::Astronomy, @response.astronomy
    assert_instance_of Time, @response.astronomy.sunrise
    assert_instance_of Time, @response.astronomy.sunset
    assert(@response.astronomy.sunrise < @response.astronomy.sunset)
  end

  test 'Atmosphere' do
    assert_instance_of YahooWeather::Atmosphere, @response.atmosphere
    assert_kind_of Numeric, @response.atmosphere.humidity
    assert_kind_of Numeric, @response.atmosphere.visibility
    assert_kind_of Numeric, @response.atmosphere.pressure
    assert(YahooWeather::Atmosphere::Barometer::ALL.include?(@response.atmosphere.barometer))
  end

  test 'Location' do
    assert_instance_of YahooWeather::Location, @response.location
    assert_equal 'San Francisco', @response.location.city
    assert_equal 'CA', @response.location.region
    assert_equal 'United States', @response.location.country
  end

  test 'Forecasts' do
    assert_not_nil @response.forecasts
    assert_kind_of Array, @response.forecasts
    assert_equal 5, @response.forecasts.length
    @response.forecasts.each do |forecast|
      assert_instance_of YahooWeather::Forecast, forecast
      assert(forecast.day && forecast.day.length == 3)
      assert_instance_of Date, forecast.date
      assert_kind_of Numeric, forecast.low
      assert_kind_of Numeric, forecast.high
      _assert_test_text(forecast.code('string'))
      assert(forecast.low <= forecast.high)
      assert(forecast.text && forecast.text.length > 0)
      _assert_valid_weather_code forecast.code
    end
  end

  test 'Units' do
    units = @response.units
    assert_instance_of YahooWeather::Units, units
    if @client.units == YahooWeather::Units::FAHRENHEIT
      assert_equal units.temperature, 'F'
      assert_equal units.distance, 'mi'
      assert_equal units.pressure, 'in'
      assert_equal units.speed, 'mph'
    else
      assert_equal units.temperature, 'C'
      assert_equal units.distance, 'km'
      assert_equal units.pressure, 'mb'
      assert_equal units.speed, 'km/h'
    end
  end

  test 'General' do
    assert_kind_of Numeric, @response.ttl
    assert_kind_of Float, @response.lat
    assert_kind_of Float, @response.long
    assert_kind_of Time, @response.last_build_date
    _assert_test_text @response.title
    _assert_test_text @response.link
    _assert_test_text @response.description
  end

private
  def _assert_valid_response (response, request_location, units,
                              city, region, country)
    assert_not_nil response
  end

  def _test_wind_direction(direction, direction_string)
    response_wind = YahooWeather::Wind.new({'direction' => direction, 'chill'=> 0, 'speed'=>0})
    assert_equal direction, response_wind.direction
    assert_kind_of String, response_wind.direction('s')
    assert_equal direction_string, response_wind.direction('s')
  end

  def _assert_valid_weather_code(code)
    (code >= 0 && code <= 47) || (code == 3200)
  end

  def _assert_test_text(text)
    text && text.length > 0
  end
end
