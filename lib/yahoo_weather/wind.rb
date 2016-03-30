class YahooWeather::Wind
  attr_reader :chill, :speed

  def initialize(payload)
    @chill     = payload['chill'].to_i
    @direction = payload['direction'].to_i
    @speed     = payload['speed'].to_f
  end

  def direction(u = 'integer')
    return @direction if u == 'integer'

    case @direction
    when 0..11
      direction_string(:n)
    when 12..33
      direction_string(:nne)
    when 34..56
      direction_string(:ne)
    when 57..78
      direction_string(:ene)
    when 79..101
      direction_string(:e)
    when 102..123
      direction_string(:ese)
    when 124..146
      direction_string(:se)
    when 147..168
      direction_string(:sse)
    when 169..191
      direction_string(:s)
    when 192..213
      direction_string(:ssw)
    when 214..236
      direction_string(:sw)
    when 237..258
      direction_string(:wsw)
    when 259..281
      direction_string(:w)
    when 282..303
      direction_string(:wnw)
    when 304..326
      direction_string(:nw)
    when 327..348
      direction_string(:nnw)
    when 349..360
      direction_string(:n)
    end
  end

  private

  def direction_string(name)
    I18n.t name, scope: [:yahoo_weather, :wind], default: name.to_s.upcase
  end
end
