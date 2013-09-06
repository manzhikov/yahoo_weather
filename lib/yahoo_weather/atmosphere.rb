class YahooWeather::Atmosphere
  class Barometer
    STEADY = 'steady'
    RISING = 'rising'
    FALLING = 'falling'

    # lists all possible barometer constants
    ALL = [ STEADY, RISING, FALLING ]
  end

  attr_reader :humidity, :visibility, :pressure, :barometer

  def initialize(payload)
    @humidity = payload['humidity'].to_i
    @visibility = payload['visibility'].to_f
    @pressure = payload['pressure'].to_f

    # map barometric pressure direction to appropriate constant
    @barometer = nil
    case payload['rising'].to_i
    when 0
      @barometer = Barometer::STEADY
    when 1
      @barometer = Barometer::RISING
    when 2
      @barometer = Barometer::FALLING
    end
  end
end