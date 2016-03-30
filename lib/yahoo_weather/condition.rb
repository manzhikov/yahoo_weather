class YahooWeather::Condition
  attr_reader :text, :temp, :date

  def initialize(payload)
    @text = payload['text']
    @code = payload['code'].to_i
    @temp = payload['temp'].to_i
    @date = Time.parse(payload['date'])
  end

  def code(u = 'integer')
    return @code if u == 'integer'
    YahooWeather.code_string(@code)
  end
end
