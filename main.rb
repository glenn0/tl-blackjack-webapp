require https://rubygems.org
require 'sinatra'

group :development do
  require 'shotgun'
end

set :sessions, true

helpers do
  def card_valuer(cards)
  	array = cards.map{|x| x[1]}

  	cards_val = 0
  	array.each do |val|
      if val == "A"
	    cards_val += 11
	  elsif val.to_i == 0 #For J, K, Q
	    cards_val += 10
	  else
	    cards_val += val.to_i
	  end
	end

    cards_val
  end
end
		
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
    # deal player
    session[:player_cards] << session[:deck].pop
    session[:player_cards] << session[:deck].pop
    # deal dealer
    session[:dealer_cards] << session[:deck].pop
    session[:dealer_cards] << session[:deck].pop

  erb :game
end

post '/hit' do
  session[:player_cards] << session[:deck].pop

  if card_valuer(session[:player_cards]) <= 21
    redirect '/playon'
  else
    redirect '/bust'
  end
end

post '/stay' do
  redirect '/playon'
end

get '/playon' do
  erb :game
end

get '/logout' do
  session[:old_user] = session[:username]
  session[:username] = nil

  erb :logout
end

get '/bust' do
  "You bust."
end