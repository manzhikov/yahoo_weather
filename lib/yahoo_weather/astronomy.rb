class YahooWeather::Astronomy
  attr_reader :sunrise, :sunset

  def initialize(payload)
    @sunrise = Time.parse(payload['sunrise'])
    @sunset  = Time.parse(payload['sunset'])
  end
end