require 'nokogiri'
require 'date'

class Weather
  attr_accessor :temp, :conditions, :time

  def initialize args
    @temp = args[:temp]
    @conditions = args[:conditions]
    @time = args[:time]
  end

  def self.create_from_xml xml_response_str
    xml_doc = Nokogiri::XML(xml_response_str)

    current_elem = xml_doc.at_css("current_conditions")
    current_args = {
      :conditions => current_elem.at_css('condition').attr('data'),
      :temp => current_elem.at_css('temp_f').attr('data'),
      :time => 'Now',
    }

    current_weather = Weather.new(current_args)

    forecasted_weather = xml_doc.css('forecast_conditions').map do |weather_elem|
      data_args = {
        :time =>  weather_elem.at_css('day_of_week').attr('data'),
        :temp => weather_elem.at_css('high').attr('data'),
        :conditions => weather_elem.at_css('condition').attr('data')
      }

      Weather.new(data_args)
    end

    forecasted_weather.unshift(current_weather)
  end
end
