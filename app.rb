require 'bundler'
Bundler.require

require_relative 'lib/game'
require_relative 'lib/player'

def play
  player1 = Player.new("Josiane")
  player2 = Player.new("José")

  while player1.life_points > 0 && player2.life_points > 0
    puts "\n\e[42m\e[30mEtat de chaque joueur :\e[0m\n\n"
    player1.show_state
    player2.show_state
    player1.attacks(player2)
    break if player2.life_points <= 0
    player2.attacks(player1)
  end
end

play