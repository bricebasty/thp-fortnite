# frozen_string_literal: true

require 'bundler'
Bundler.require

require_relative 'lib/game'
require_relative 'lib/player'

def user_prompt
  print "\e[1m\e[33m> "
  input = gets.chomp.downcase
  print "\e[0m"
  input
end

def play
  puts <<-ACCUEIL

  \e[46m\e[30m\e[1m-----------------------------------------------------\e[0m
  \e[46m\e[30m\e[1m|    Bienvenue sur 'ILS VEULENT TOUS MA POO' !      |\e[0m
  \e[46m\e[30m\e[1m|  Le but du jeu est d'être le dernier survivant !  |\e[0m
  \e[46m\e[30m\e[1m-----------------------------------------------------\e[0m
  ACCUEIL
  puts "\n\e[33mQuel est ton prénom, humain ?\e[0m"
  print "\e[1m\e[33m> "
  user = HumanPlayer.new(gets.chomp)
  print "\e[0m"
  enemies = [player1 = Player.new('Josiane'), player2 = Player.new('José')]

  # Boucle de jeu
  while user.life_points.positive? && (player1.life_points.positive? || player2.life_points.positive?)
    user.show_state
    sleep 1

    # Menu
    loop do
      puts <<~MENU
        \n\e[33m\e[4mQuelle action veux-tu effectuer ?\e[0m\n
        \e[42m\e[30mA\e[0m Chercher une meilleure arme
        \e[41m\e[30mS\e[0m Chercher à se soigner
        \e[30m\e[43m1\e[0m Attaquer Josiane (#{player1.life_points} points de vie)
        \e[30m\e[44m2\e[0m Attaquer José (#{player2.life_points} points de vie)\n
        \e[30m\e[47mX\e[0m Quitter
      MENU

      input = user_prompt
      case input
      when 'a' then user.search_weapon
      when 's' then user.search_health_pack
      when '1' then user.attacks(player1)
      when '2' then user.attacks(player2)
      when 'x' then break
      else
        puts "\n\e[41m\e[30m\e[1mEntrée invalide.\e[0m"
        retry_flag = true
      end
      break unless retry_flag

      false
    end
    # Les ennemis attaquent le joueur
    puts "\n\e[5m\e[1m\e[35mLes autres joueurs t'attaquent !" if enemies.any? { _1.life_points.positive? }
    sleep 1
    enemies.each { _1.attacks(user) if _1.life_points.positive? }
  end

  puts "\nLa partie est finie"
  if user.life_points.positive?
    puts "\n\e[30m\e[42mBRAVO ! TU AS GAGNE !\n"
  else
    puts "\n\e[30m\e[41mLoser ! Tu as perdu !\n"
  end
end

play
