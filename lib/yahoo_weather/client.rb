class YahooWeather::Client
  attr_reader :units, :woeid

  def fetch(woeid, units = YahooWeather::Units::FAHRENHEIT)
    @units = units
    @woeid = woeid
    doc = Nokogiri::XML(read_xml)
    YahooWeather::Response.new(doc)
  end

  def fetch_by_location(location, units = YahooWeather::Units::FAHRENHEIT)
    url = "http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20geo.placefinder%20where%20text%3D%22#{::CGI.escape(location)}%22%20and%20gflags%3D%22R%22"
    xml = fetch_xml(url)
    doc = Nokogiri::XML(xml)
    woeid = doc.at('woeid').children.text
    fetch(woeid, units)
  rescue
    nil
  end

private
  def get_url
    "http://weather.yahooapis.com/forecastrss?w=#{@woeid}&u=#{@units}"
  end

  def read_xml
    save_cache unless Rails.cache.exist? cache_key
    read_cache
  end

  def fetch_xml(url = get_url)
    begin
      response = open(url)
    rescue OpenURI::HTTPError => e
      raise RuntimeError.new("Failed to get xml. Got a bad status code #{e.message}")
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