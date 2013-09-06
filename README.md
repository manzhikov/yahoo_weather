# yahoo_weather
[![Build Status](https://travis-ci.org/manzhikov/yahoo_weather.png?branch=master)](https://travis-ci.org/manzhikov/yahoo_weather)

A Ruby object-oriented interface to the Yahoo! Weather feed.

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