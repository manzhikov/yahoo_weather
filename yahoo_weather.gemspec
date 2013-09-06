$:.push File.expand_path('../lib', __FILE__)
require 'yahoo_weather/version'

Gem::Specification.new do |s|
  s.name        = 'yahoo_weather'
  s.version     = YahooWeather::VERSION.dup
  s.platform    = Gem::Platform::RUBY
  s.author      = 'Ildar Manzhikov'
  s.email       = 'manzhikov@gmail.com'
  s.homepage    = 'http://github.com/manzhikov/yahoo_weather'
  s.summary     = 'YahooWeather fetcher'
  s.description = 'Weather'
  s.license     = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.require_paths = ['lib']
  s.test_files = Dir['test/**/*']
  s.add_dependency 'rails', '>= 3.1.0'
  s.add_dependency 'nokogiri'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'fakeweb', '~> 1.3'
end