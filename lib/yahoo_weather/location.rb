class YahooWeather::Location
  attr_reader :city, :region, :country

  def initialize(payload)
    @city    = payload['city']
    @region  = payload['region']
    @country = payload['country']
  end
end