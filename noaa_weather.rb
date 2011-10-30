require 'open-uri'
require 'rubygems'
require 'nokogiri'
require 'rest_client'
require 'date'
require 'net/http'
require 'json'

module NOAA
  WEATHER_URL = 'http://www.weather.gov/forecasts/xml/sample_products/browser_interface/ndfdXMLclient.php'

  #http://erikeldridge.wordpress.com/2010/02/18/1st-attempt-at-a-ruby-yql-utility-function/
  def geocode(query)
      yql_query = %{
        use 'http://github.com/yql/yql-tables/raw/master/weather/weather.woeid.xml' as weather;
        select * from weather where w in (
        select woeid from geo.places where text="#{query}");
      }

      uri = "http://query.yahooapis.com/v1/public/yql"
      response = Net::HTTP.post_form( URI.parse(uri), {
        'q'       => yql_query,
        'format'  => 'json'
      })

      json = JSON.parse( response.body )
      center = json["query"]["results"]["rss"][0]["channel"]["item"]
      return center
  end
  module_function :geocode

  def current_weather(query)
    params = {
      :product  => 'time-series',
      :begin    => DateTime.now.to_s,
      :end      => (DateTime.now + 3).to_s,
      :appt     => 'appt',
      :wx       => :wx,
    }

    if query.length == 1  then
      params[:zipCodeList] = query[:zip]
    else
      params[:lat] = query[:lat]
      params[:lon] = query[:lng]
    end

    response = RestClient.get WEATHER_URL, {
      :params => params
    }

    parsed_resp = Nokogiri::XML(response)

    times =  parsed_resp.css("time-layout start-valid-time").map do |date_elem|
      DateTime.parse(date_elem.content)
    end
    temps = parsed_resp.css("temperature[type=apparent] value").map do |temp_elem|
      temp_elem.content
    end

    weather_conds = parsed_resp.css("weather-conditions value").map do |weather_elem|
      intensity = weather_elem.attr('intensity')
      intensity = "" unless intensity != 'none'
      {
        :coverage => weather_elem.attr('coverage'),
        :intensity => intensity,
        :weathertype => weather_elem.attr('weather-type'),
      }
    end

    zipped = times.zip(temps, weather_conds)

    dict = zipped.map do |z|
      {
        :time => z[0],
        :temp => z[1],
        :conditions => z[2],
      }
    end

    return dict
  end
  module_function :current_weather

  def history_weather(station_code)
    url = "http://www.weather.gov/data/obhistory/#{station_code}.html"
    today = Date.today.day
    yesterday = (Date.today - 1).day

    html_doc = Nokogiri::HTML(open(url))
    table = html_doc.css('table')[3]
    rows = table.css('tr[bgcolor!="#b0c4de"]')
    temps = rows.map do |row|
      td = row.css('td')
      p td.to_xml
      date = td[0].content.to_i
      if date == today || date == yesterday then
        if(td[8].content != '') then
          return {
            :max => td[8].content.to_i,
            :min => td[9].content.to_i,
          }
        end
      end
    end
    return temps
  end
  module_function :history_weather
end
