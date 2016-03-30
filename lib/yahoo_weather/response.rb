class YahooWeather::Response
  attr_reader :doc, :title, :link, :description,
              :language, :last_build_date, :ttl,
              :lat, :long

  def initialize(doc)
    @doc = doc['query']['results']['channel']
    @title            = @doc['item']['title']
    @link             = @doc['link']
    @description      = @doc['description']
    @language         = @doc['language']
    @last_build_date  = Time.parse(@doc['lastBuildDate'])
    @ttl              = @doc['ttl'].to_i
    @lat              = @doc['item']['lat'].to_f
    @long             = @doc['item']['long'].to_f
  end

  def location
    YahooWeather::Location.new(@doc['location'])
  end

  def units
    YahooWeather::Units.new(@doc['units'])
  end

  def astronomy
    YahooWeather::Astronomy.new(@doc['astronomy'])
  end

  def atmosphere
    YahooWeather::Atmosphere.new(@doc['atmosphere'])
  end

  def condition
    YahooWeather::Condition.new(@doc['item']['condition'])
  end

  def wind
    YahooWeather::Wind.new(@doc['wind'])
  end

  def forecasts
    forecasts = []
    @doc['item']['forecast'].each do |forecast|
      forecasts << YahooWeather::Forecast.new(forecast)
    end
    forecasts
  end
end
