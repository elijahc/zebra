require 'sinatra'
require 'sinatra/static_assets'
require 'sinatra/flash'
require 'haml'
require 'json'
require 'mongoid'
require './zebra.rb'

use Rack::Logger

enable :sessions

# TODO: add persistence layer (mongodb)
@@r = Zebrascope.new(1,999999)

helpers do
  def logger
    request.logger
  end

  def styled_flash
    puts "<div id='flash'>"
    flash.each do |k,v|
      puts "div class='alert alert-#{k.to_s}'>#{v}</div>"
    end
    puts "</div>"
  end
end

# UI service endpoints
get '/' do
  haml :index
end

get '/print' do
  haml :print
end

get '/properties' do
  [200, {}, @@r.properties.to_json]
end

# GET API routes
get '/check/value/:value' do
  redirect "/check/range/#{params[:value]}/to/#{params[:value]}"
end

get '/check/range/:start/to/:end' do
  # TODO: Add ability to check if this value is addable
  response =  @@r.addable?( params[:start].to_i..params[:end].to_i )
  response.store('check', response['addable'])
  [ 200, {}, response.to_json ]
end


# POST API Routes
post '/add/range/:start/to/:end' do
  startval = params[:start].to_i
  endval   = params[:end].to_i
  puts "Adding range #{startval}..#{endval}"

  # Flashes aren't currently working, still trying to figure that one out...
  begin
    puts @@r.add( startval..endval )
    flash[:success] = 'Added range successfully'
  rescue => e
    flash[:error] = e.message
    puts flash.inspect
  end

end

post '/new_span/:start/to/:finish' do
  start = params[:start].to_i
  finish = params[:finish].to_i

  @@r = Zebrascope.new(start, finish)
end

post '/add/value/:value' do
  value = params[:value].to_i
  puts "Adding value #{value}"

  puts @@r.add(value)
end

