require 'rubygems'
require 'sinatra'
#require 'shotgun'


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

  def card_imager(card)
      suit = card[0].to_s.downcase
      face_val = card[1].to_s.downcase
      "/images/cards/"+suit+"_"+face_val+".jpg"
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
    face_val = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace']
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

  session[:card_hide] = true
  erb :game
end

post '/hit' do
  session[:player_cards] << session[:deck].pop

  if card_valuer(session[:player_cards]) <= 21
    redirect '/playon'
  else
    redirect '/pick_a_winner'
  end
end

post '/dealer_hit' do
  session[:dealer_cards] << session[:deck].pop

  if card_valuer(session[:dealer_cards]) == 21
    redirect '/pick_a_winner'
  elsif card_valuer(session[:dealer_cards]) > 21
    redirect '/pick_a_winner'
  elsif card_valuer(session[:dealer_cards]) >= 17
    redirect '/pick_a_winner'
  else
    redirect '/dealer_playon'
  end
end

post '/stay' do
  if card_valuer(session[:dealer_cards]) == 21
    redirect '/pick_a_winner'
  elsif card_valuer(session[:dealer_cards]) >= 17
    redirect '/pick_a_winner'
  else
    redirect '/dealer_playon'
  end
end

get '/playon' do
  erb :game
end

get '/dealer_playon' do
  session[:dealer_hide] = false
  erb :game_dealerturn
end

get '/logout' do
  session[:old_user] = session[:username]
  session[:username] = nil

  erb :logout
end

get '/pick_a_winner' do
  if card_valuer(session[:player_cards]) == 21 && card_valuer(session[:dealer_cards]) != 21
    session[:result] = "You've got Blackjack!"
  elsif card_valuer(session[:player_cards]) == 21 && card_valuer(session[:dealer_cards]) == 21
    session[:result] = "It's a draw."
  elsif card_valuer(session[:player_cards]) > 21
    session[:result] = "You bust."
  elsif card_valuer(session[:dealer_cards]) > 21 && card_valuer(session[:player_cards]) <= 21
    session[:result] = "Dealer busts, you win!"
  elsif card_valuer(session[:player_cards]) > card_valuer(session[:dealer_cards]) && card_valuer(session[:player_cards]) <= 21
    session[:result] = "You win!"
  elsif card_valuer(session[:dealer_cards]) > card_valuer(session[:player_cards]) && card_valuer(session[:dealer_cards]) <= 21
    session[:result] = "Dealer wins."
  else
    session[:result] = "It's a draw."
  end

  redirect '/result'
end

get '/result' do
  erb :result
end