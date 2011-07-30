require 'rubygems'
require 'sinatra'
require 'haml'

require './noaa_weather'

get '/' do
  redirect "/#{params['zip']}" unless params['zip'] == nil
  haml :index
end

get '/:zip' do
  zip = params['zip'].to_i
  temps = NOAA.current_weather(zip)
  @zip = zip
  @temps = temps
  @dateformat = "%a  %b %d"
  haml :index
end
