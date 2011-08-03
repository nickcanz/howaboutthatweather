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

  yql_query = NOAA.yql(%{
    select * from geo.places where text='#{query}'
  })
  center = yql_query["query"]["results"]["place"].first["centroid"]

  temps = NOAA.current_weather({
    :lat => center["latitude"],
    :lng => center["longitude"]
  })

  @query = query
  @temps = temps
  @dateformat = "%a  %b %d"
  haml :index
end
