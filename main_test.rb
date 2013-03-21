require 'rubygems'
require 'sinatra'
require 'shotgun'

set :sessions, true

get '/' do
  "Hello World! Woohoo!"
end

get '/template' do
  erb :hi
end

get '/nested_template' do
  erb :"/users/profile"
end

get '/nothere' do
  redirect '/'
end