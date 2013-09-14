require 'json'
require 'open-uri'

module YahooWeather
  def self.code_string(id)
    I18n.t id, scope: [:yahoo_weather, :code]
  end
end

require 'yahoo_weather/client'
require 'yahoo_weather/response'
require 'yahoo_weather/wind'
require 'yahoo_weather/atmosphere'
require 'yahoo_weather/astronomy'
require 'yahoo_weather/condition'
require 'yahoo_weather/forecast'
require 'yahoo_weather/location'
require 'yahoo_weather/units'