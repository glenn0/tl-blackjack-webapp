require 'rubygems'
require 'sinatra'
require 'shotgun'

set :sessions, true

get '/' do
  erb :new_user_form
end

post '/myaction' do
  puts params['username'], params['date'], params['password']
end