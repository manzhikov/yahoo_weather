class YahooWeather::Response
  attr_reader :doc, :title, :link, :description,
              :language, :last_build_date, :ttl,
              :lat, :long

  def initialize(doc)
    @doc = doc
    @title            = get_text('item/title')
    @link             = get_text('link')
    @description      = get_text('description')
    @language         = get_text('language')
    @last_build_date  = Time.parse(get_text('lastBuildDate'))
    @ttl              = get_text('ttl').to_i
    @lat              = get_text('item/geo|lat').to_f
    @long             = get_text('item/geo|long').to_f
  end

  def location
    YahooWeather::Location.new(@doc.at('yweather|location'))
  end

  def units
    YahooWeather::Units.new(@doc.at('yweather|units'))
  end

  def astronomy
    YahooWeather::Astronomy.new(@doc.at('yweather|astronomy'))
  end

  def atmosphere
    YahooWeather::Atmosphere.new(@doc.at('yweather|atmosphere'))
  end

  def condition
    YahooWeather::Condition.new(@doc.at('item/yweather|condition'))
  end

  def wind
    YahooWeather::Wind.new(@doc.at('yweather|wind'))
  end

  def forecasts
    forecasts = []
    @doc.search('item/yweather|forecast').each do |forecast|
      forecasts << YahooWeather::Forecast.new(forecast)
    end
    forecasts
  end

private
  def get_text(tag_name)
    @doc.at(tag_name).children.text
  end
end