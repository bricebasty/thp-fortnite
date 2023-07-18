require 'bundler'
Bundler.require

require_relative 'lib/game'
require_relative 'lib/player'


def play
  puts <<-ACCUEIL

  \e[46m\e[30m\e[1m-----------------------------------------------------\e[0m
  \e[46m\e[30m\e[1m|    Bienvenue sur 'ILS VEULENT TOUS MA POO' !      |\e[0m
  \e[46m\e[30m\e[1m|  Le but du jeu est d'être le dernier survivant !  |\e[0m
  \e[46m\e[30m\e[1m-----------------------------------------------------\e[0m
  ACCUEIL
  puts "\n\e[33mQuel est ton prénom, humain ?\e[0m"
  print "\e[1m\e[33m> \e[0m"
  user = HumanPlayer.new(gets.chomp)

  my_game = Game.new("Brice")

  while my_game.is_still_ongoing?
    my_game.show_players
    my_game.menu
    my_game.menu_choice(my_game.user_prompt)
    my_game.enemies_attack
  end
  my_game.end
end

binding.pry