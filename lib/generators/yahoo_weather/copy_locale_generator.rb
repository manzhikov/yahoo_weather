module YahooWeather
  module Generators
    class CopyLocaleGenerator < Rails::Generators::Base
      source_root File.expand_path(__FILE__)
      argument :locale, type: :string, default: 'en'
      def copy_locale
        copy_file "../../../../config/locales/#{locale.underscore}.yml", "config/locales/yahoo_weather.#{locale.underscore}.yml"
      end
    end
  end
end
