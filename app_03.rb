# frozen_string_literal: true

require 'bundler'
Bundler.require

require_relative 'lib/game'
require_relative 'lib/player'

def welcome
  puts <<-ACCUEIL
  \e[46m\e[30m\e[1m-----------------------------------------------------\e[0m
  \e[46m\e[30m\e[1m|    Bienvenue sur 'ILS VEULENT TOUS MA POO' !      |\e[0m
  \e[46m\e[30m\e[1m|  Le but du jeu est d'être le dernier survivant !  |\e[0m
  \e[46m\e[30m\e[1m-----------------------------------------------------\e[0m
  ACCUEIL

  puts "\n\e[33mQuel est ton prénom, humain ?\e[0m"
  print "\e[1m\e[33m> \e[0m"
end

# Méthode principale pour jouer
def play
  welcome
  my_game = Game.new(gets.chomp)
  while my_game.still_ongoing?
    my_game.new_players_in_sight
    my_game.show_players
    my_game.menu
    my_game.menu_choice(my_game.user_prompt)
    my_game.enemies_in_sight_attack
  end
  my_game.end
end

# Appel de la méthode pour jouer
play
