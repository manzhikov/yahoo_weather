class YahooWeather::Forecast
  attr_reader :date, :high, :low, :text, :day

  def initialize(payload)
    @date = Date.parse(payload['date'])
    @text = payload['text']
    @day  = payload['day']
    @code = payload['code'].to_i
    @high = payload['high'].to_i
    @low  = payload['low'].to_i
  end

  def code(u='integer')
    return @code if u == 'integer'
    YahooWeather.code_string(@code)
  end
end