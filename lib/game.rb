# frozen_string_literal: true

require 'bundler'
Bundler.require

require_relative 'player'

# La classe Game représente la logique du jeu et les interactions entre le joueur humain et les ennemis.
class Game
  attr_accessor :human_player, :enemies_in_sight, :players_left

  def initialize(name)
    @human_player = HumanPlayer.new(name.to_s) # Crée le joueur humain avec le nom donné
    @enemies_in_sight = [] # Initialise le tableau des ennemis en vue comme vide
    @players_left = 10 # Initialise le nombre de joueurs restants à 10
  end

  def kill_player(player)
    @enemies_in_sight.delete(player) # Supprime le joueur du tableau des ennemis en vue
    @players_left -= 1 # Décrémente le nombre de joueurs restants
  end

  def still_ongoing?
    # Vérifie si le joueur humain est en vie et s'il reste des joueurs
    @human_player.life_points.positive? && @players_left.positive?
  end

  def new_players_in_sight
    return display_all_players_in_sight_message if all_players_in_sight?

    new_players = rand(1..6)
    case new_players
    when 1 then no_new_players_message
    when (2..4) then add_enemy_and_display_message
    when (5..6) then add_multiple_enemies_and_display_message(2)
    end
  end

  def all_players_in_sight?
    @enemies_in_sight.count == @players_left || @enemies_in_sight.length >= 10
  end

  def no_new_players_message
    puts "\n\e[36mAucun nouveau joueur adverse n'arrive\e[0m"
  end

  def add_enemy_and_display_message
    add_enemy
    puts "\n\e[36m1 adversaire arrive\e[0m"
  end

  def add_multiple_enemies_and_display_message(count)
    count.times do
      break if @enemies_in_sight.length >= 10

      add_enemy
    end
    puts "\n\e[36m#{count} adversaires arrivent\e[0m"
  end

  def display_all_players_in_sight_message
    puts "\n\e[36mTous les joueurs sont déjà en vue\e[0m"
  end

  def add_enemy
    if @enemies_in_sight.count < @players_left
      @enemies_in_sight << Player.new("Joueur_#{rand(1000..9999)}")
    end
  end

  def show_players
    @human_player.show_state # Affiche l'état du joueur humain
    sleep 0.5
    puts "\nIl y a \e[31m\e[1m#{@players_left} ennemis à tuer" # Affiche le nombre d'ennemis en vue
  end

  def user_prompt
    print "\e[1m\e[33m> " # Affiche le prompt de saisie utilisateur
    input = gets.chomp.downcase
    print "\e[0m"
    input
  end

  def menu
    puts <<~MENU
      \n\e[33m\e[4mQuelle action veux-tu effectuer ?\e[0m\n
      \e[42m\e[30mA\e[0m Chercher une meilleure arme
      \e[41m\e[30mS\e[0m Chercher à se soigner
    MENU
    @enemies_in_sight.each.with_index do |e, i|
      color_code = (43 + i) % 4 + 43 # Calcul du code de couleur basé sur l'index de l'ennemi
      puts "\e[30m\e[#{color_code}m#{i + 1}\e[0m Attaquer #{e.name} (#{e.life_points} points de vie)"
    end
    puts "\n\e[30m\e[47mX\e[0m Quitter"
  end

  def menu_choice(input)
    case input
    when 'a' then @human_player.search_weapon
    when 's' then @human_player.search_health_pack
    when *('1'..'10').to_a then @human_player.attacks(@enemies_in_sight[input.to_i - 1])
    when 'x' then exit
    else puts "\n\e[30m\e[47mTu passes ton tour...\e[0m\n"
    end; @enemies_in_sight.each { |e| kill_player(e) if e.life_points <= 0 }
  end

  def enemies_in_sight_attack
    puts "\n\e[5m\e[1m\e[35mLes autres joueurs t'attaquent !" if @enemies_in_sight.any? { _1.life_points.positive? }
    sleep 0.5
    @enemies_in_sight.each do
      # Les ennemis attaquent le joueur humain s'ils sont encore en vie
      _1.attacks(@human_player) if _1.life_points.positive?
    end
  end

  def end
    puts "\nLa partie est finie" # Affiche que la partie est terminée
    if @human_player.life_points.positive?
      puts "\n\e[30m\e[42mBRAVO ! TU AS GAGNE !\n"  # Affiche un message de victoire si le joueur humain est en vie
    else
      puts "\n\e[30m\e[41mLoser ! Tu as perdu !\n"  # Affiche un message de défaite si le joueur humain est mort
    end
  end
end
