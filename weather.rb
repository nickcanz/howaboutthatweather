require 'nokogiri'
require 'date'

class Weather
  attr_accessor :high, :low, :conditions, :time

  def self.city
    @@city
  end

  def initialize args
    @high = args[:high]
    @low = args[:low]
    @conditions = args[:conditions]
    @time = args[:time]
  end

  def self.create_from_xml xml_response_str
    xml_doc = Nokogiri::XML(xml_response_str)

    @@city = xml_doc.at_css("city").attr('data')

    current_elem = xml_doc.at_css("current_conditions")
    current_args = {
      :conditions => current_elem.at_css('condition').attr('data'),
      :high => current_elem.at_css('temp_f').attr('data'),
      :low => current_elem.at_css('temp_f').attr('data'),
      :time => 'Now',
    }

    current_weather = Weather.new(current_args)

    forecasted_weather = xml_doc.css('forecast_conditions').map do |weather_elem|
      data_args = {
        :time =>  weather_elem.at_css('day_of_week').attr('data'),
        :high => weather_elem.at_css('high').attr('data'),
        :low => weather_elem.at_css('low').attr('data'),
        :conditions => weather_elem.at_css('condition').attr('data')
      }

      Weather.new(data_args)
    end

    forecasted_weather.unshift(current_weather)
  end
end
