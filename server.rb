require 'sinatra'
require 'sinatra/static_assets'
require 'sinatra/flash'
require 'haml'
require 'json'
require './zebra.rb'

# TODO: add persistence layer (mongodb)
@@r = Zebrascope.new(0,50)

get '/' do
  haml :index
end

get '/print' do
  haml :print
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

  begin
    puts @@r.add( startval..endval )
    flash[:success] = 'Added range successfully'
  rescue => e
    flash[:error] = e.message
  end

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

def styled_flash
  puts "<div id='flash'>"
  flash.each do |k,v|
    puts "div class='alert alert-#{k.to_s}'>#{v}</div>"
  end
  puts "</div>"
end
