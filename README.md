# yahoo_weather 
[![Build Status](https://travis-ci.org/manzhikov/yahoo_weather.png?branch=master)](https://travis-ci.org/manzhikov/yahoo_weather)
[![Code Climate](https://codeclimate.com/github/manzhikov/yahoo_weather/badges/gpa.svg)](https://codeclimate.com/github/manzhikov/yahoo_weather)

A Ruby object-oriented interface to the Yahoo! Weather JSON API.

It supports caching and i18n.


## Installation

    $ gem install yahoo_weather


Include in your Gemfile:

```ruby
gem 'yahoo_weather'
```

## API

http://developer.yahoo.com/weather/

## Example

Fetch by woeid:
```ruby
client = YahooWeather::Client.new
response = client.fetch(12797168)
response.units.temperature        # "F"
response.condition.temp           # 60
response.wind.direction           # 110
response.wind.direction('string') # "ESE"
response.condition.code           # 29
response.condition.code('string') # "Partly cloudy (night)"
```
FYI: If you want to use string condition code don't forget to copy locales

Fetch by location:
```ruby
client = YahooWeather::Client.new
response = client.fetch_by_location('New York')
```

## Locales

Copy locale command:

```ruby
rails g yahoo_weather:copy_locale en
```

## Available Locales

Available locales are:

> en, ru

## License

MIT License. Copyright 2013 Ildar Manzhikov <manzhikov@gmail.com>. http://manzhikov.com
