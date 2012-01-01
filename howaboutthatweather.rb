require 'rubygems'
require 'sinatra'
require 'haml'
require 'rdiscount'
require 'nokogiri'
require 'rest_client'
require 'cgi'
require './weather'

get '/' do
  redirect "/#{CGI.escape(params['query'])}" unless params['query'] == nil
  haml :index
end

get '/:query' do
  query = params['query']

  weather_data = get_weather query
  @query = query
  @weather_data = weather_data
  haml :index
end

def get_weather query
  url = "http://www.google.com/ig/api?weather=#{CGI.escape(query)}"
  response = RestClient.get(url)
  Weather.create_from_xml(response)
end
