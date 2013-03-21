require 'rubygems'
require 'sinatra'
require 'shotgun'

set :sessions, true

get '/form' do
  erb :form
end

post '/myaction' do
  puts params['username'], params['date'], params['password']
end