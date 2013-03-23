require 'rubygems'
require 'sinatra'
require 'shotgun'

set :sessions, true

get '/' do
  if session[:username]
  	redirect '/signup'
  else
  	redirect '/game'
  end
end

get '/signup' do
	erb :new_user_form
end

post '/saveuser' do
  session[:username] = params['username']
  puts params['username']
  redirect '/game'
end

get '/game' do
  puts "This is in /game."
  puts session[:username]
end