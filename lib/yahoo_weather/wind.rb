class YahooWeather::Wind
  attr_reader :chill, :speed

  def initialize(payload)
    @chill     = payload['chill'].to_i
    @direction = payload['direction'].to_i
    @speed     = payload['speed'].to_f
  end

  def direction(u = 'integer')
    return @direction if u == 'integer'

    val=((@direction.to_f/22.5)+0.5).to_i
    arr=[:n, :nne, :ne, :ene, :e, :ese, :se, :sse, :s, :ssw, :sw, :wsw, :w, :wnw, :nw, :nnw]
    direction_string(arr[(val % 16)])
  end

  private

  def direction_string(name)
    I18n.t name, scope: [:yahoo_weather, :wind], default: name.to_s.upcase
  end
end
