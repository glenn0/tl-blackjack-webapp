require 'rubygems'
require 'sinatra'
require 'shotgun'

set :sessions, true

get '/' do
  if session[:username]
    redirect '/game'
  else
    redirect '/signup'
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
  # deck
    suits = ['Hearts', 'Clubs', 'Diamonds', 'Spades']
    face_val = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
    session[:deck] = suits.product(face_val).shuffle!
  # deal cards
    session[:dealer_cards] = []
    session[:player_cards] = []
    session[:dealer_cards] << session[:deck].pop
    session[:player_cards] << session[:deck].pop
    session[:dealer_cards] << session[:deck].pop
    session[:player_cards] << session[:deck].pop
    # player cards

  erb :game
end