class YahooWeather::Client
  attr_reader :units, :woeid

  def fetch(woeid, units = YahooWeather::Units::FAHRENHEIT)
    @units = units
    @woeid = woeid
    doc = Nokogiri::XML(read_xml)
    YahooWeather::Response.new(doc)
  end

private
  def get_url
    "http://weather.yahooapis.com/forecastrss?w=#{@woeid}&u=#{@units}"
  end

  def read_xml
    save_cache unless Rails.cache.exist? cache_key
    read_cache
  end

  def fetch_xml
    begin
      response = open(get_url)
    rescue OpenURI::HTTPError => e
      raise RuntimeError.new("Failed to get weather. Got a bad status code #{e.message}")
    end

    response.read
  end

  def save_cache
    Rails.cache.write(cache_key, fetch_xml, expires_in: 1.minute)
  end

  def read_cache
    Rails.cache.read cache_key
  end

  def cache_key
    "yahoo_weather_#{@woeid}_#{@units}"
  end
end