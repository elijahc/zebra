require 'sinatra'
require 'sinatra/static_assets'
require 'haml'
require 'json'
require './zebra.rb'

# TODO: add persistence layer (mongodb)
@@r = Zebrascope.new(0,50)

get '/' do
  haml :index
end

get '/properties' do
  [200, {}, @@r.properties.to_json]
end

get '/range/:start/to/:end' do
  # TODO: Add ability to check if this value is addable
end

post '/range/:start/to/:end' do
  startval = params[:start].to_i
  endval   = params[:end].to_i
  puts "Adding range #{startval}..#{endval}"

  puts @@r.add( startval..endval )
end

post '/new_span/:start/to/:finish' do
  start = params[:start].to_i
  finish = params[:finish].to_i

  @@r = Rangetracker.new(start, finish)
end

post '/value/:value' do
  value = params[:value].to_i
  puts "Adding value #{value}"

  puts @@r.add(value)
end