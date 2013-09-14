class YahooWeather::Client
  attr_reader :units, :woeid

  def fetch(woeid, units = YahooWeather::Units::FAHRENHEIT)
    @units = units
    @woeid = woeid
    doc = JSON(read_json)
    if doc['query']['count'] > 0
      YahooWeather::Response.new(doc)
    else
      nil
    end
  end

  def fetch_by_location(location, units = YahooWeather::Units::FAHRENHEIT)
    woeid_cache_key = "yahoo_weather_woeid for #{location}"
    unless Rails.cache.exist? woeid_cache_key
      url = "http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20geo.placefinder%20where%20text%3D%22#{::CGI.escape(location)}%22&format=json&callback="
      json = fetch_json(url)
      doc = JSON(json)
      if doc['query']['count'] > 0
        woeid = doc['query']['results']['Result']['woeid']
        Rails.cache.write(woeid_cache_key, woeid)
      else
        return nil
      end
    else
      woeid = Rails.cache.read woeid_cache_key
    end
    fetch(woeid, units)
  rescue
    nil
  end

private
  def get_url
    "http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%3D#{@woeid}%20and%20u%3D%22#{@units}%22&format=json&callback="
  end

  def read_json
    save_cache unless Rails.cache.exist? cache_key
    read_cache
  end

  def fetch_json(url = get_url)
    begin
      response = open(url)
    rescue OpenURI::HTTPError => e
      raise RuntimeError.new("Failed to get xml. Got a bad status code #{e.message}")
    end

    response.read
  end

  def save_cache
    Rails.cache.write(cache_key, fetch_json, expires_in: 1.minute)
  end

  def read_cache
    Rails.cache.read cache_key
  end

  def cache_key
    "yahoo_weather_#{@woeid}_#{@units}"
  end
end