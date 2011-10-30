require 'rubygems'
require 'sinatra'
require 'haml'
require 'rdiscount'

require './noaa_weather'

get '/' do
  redirect "/#{params['query']}" unless params['query'] == nil
  haml :index
end

get '/:query' do
  query = params['query']
  center = NOAA.geocode(query)

  weather_data = NOAA.current_weather({
    :lat => center["lat"],
    :lng => center["long"]
  })

  @query = query
  @weather_data = weather_data
  @dateformat = "%a  %b %d"
  haml :index
end
