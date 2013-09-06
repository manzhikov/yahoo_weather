class YahooWeather::Units
  FAHRENHEIT = 'f'
  CELSIUS = 'c'

  attr_reader :temperature, :distance, :pressure, :speed

  def initialize(payload)
    @temperature = payload['temperature']
    @distance    = payload['distance']
    @pressure    = payload['pressure']
    @speed       = payload['speed']
  end
end
