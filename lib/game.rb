require 'bundler'
Bundler.require

require_relative 'player'

class Game
  attr_accessor :human_player, :enemies_in_sight, :players_left

  def initialize(name)
    @human_player = HumanPlayer.new("#{name}")  # Crée le joueur humain avec le nom donné
    @enemies_in_sight = []  # Initialise le tableau des ennemis en vue comme vide
    @players_left = 10  # Initialise le nombre de joueurs restants à 10
  end

  def kill_player(player)
    @enemies_in_sight.delete(player)  # Supprime le joueur du tableau des ennemis en vue
    @players_left -= 1  # Décrémente le nombre de joueurs restants
  end

  def is_still_ongoing?
    @human_player.life_points > 0 && @players_left > 0  # Vérifie si le joueur humain est en vie et s'il reste des joueurs
  end

  def new_players_in_sight
    new_players =  rand(1..6)  # Génère un nombre aléatoire de nouveaux joueurs
    if @enemies_in_sight.count != @players_left && @enemies_in_sight.length <= 10
      # Vérifie s'il y a encore des joueurs à ajouter et si le nombre total d'ennemis en vue est inférieur ou égal à 10
      case new_players
      when 1
        puts "\n\e[36mAucun nouveau joueur adverse n'arrive\e[0m"  # Aucun nouveau joueur n'arrive
      when (2..4)
        @enemies_in_sight << Player.new("Joueur_#{rand(1000..9999)}")  # Ajoute un nouvel ennemi dans le tableau
        puts "\n\e[36m1 adversaire arrive\e[0m"  # Affiche qu'un nouvel ennemi arrive
      when (5..6)
        2.times do
          break if @enemies_in_sight.length >= 10  # Arrête l'ajout d'ennemis si le nombre total atteint 10
          @enemies_in_sight << Player.new("Joueur_#{rand(1000..9999)}")  # Ajoute deux nouveaux ennemis dans le tableau
        end
        puts "\n\e[36m2 adversaires arrivent\e[0m"  # Affiche que deux nouveaux ennemis arrivent
      end
    else
      puts "\n\e[36mTous les joueurs sont déjà en vue\e[0m"  # Affiche que tous les joueurs sont déjà en vue
    end
  end

  def show_players
    @human_player.show_state  # Affiche l'état du joueur humain
    sleep 0.5
    puts "\nIl y a \e[31m\e[1m#{@enemies_in_sight.count} ennemis à tuer"  # Affiche le nombre d'ennemis en vue
  end

  def user_prompt
    print "\e[1m\e[33m> "  # Affiche le prompt de saisie utilisateur
    input = gets.chomp.downcase
    print "\e[0m"
    return input
  end

  def menu
    puts <<~MENU
    \n\e[33m\e[4mQuelle action veux-tu effectuer ?\e[0m\n
    \e[42m\e[30mA\e[0m Chercher une meilleure arme
    \e[41m\e[30mS\e[0m Chercher à se soigner
    MENU
    @enemies_in_sight.each.with_index do |e, i|
      color_code = (43 + i) % 4 + 43  # Calcul du code de couleur basé sur l'index de l'ennemi
      puts "\e[30m\e[#{color_code}m#{i+1}\e[0m Attaquer #{e.name} (#{e.life_points} points de vie)"  # Affiche l'option d'attaque pour chaque ennemi
      i += 1
    end
    print "\n"
    puts "\e[30m\e[47mX\e[0m Quitter"  # Affiche l'option pour quitter le jeu
  end

  def menu_choice(input)
    case input
    when "a" then @human_player.search_weapon  # Cherche une meilleure arme
    when "s" then @human_player.search_health_pack  # Cherche à se soigner
    when *("1".."10").to_a
      enemy_index = input.to_i - 1  # Convertit l'entrée utilisateur en index de tableau
      @human_player.attacks(@enemies_in_sight[enemy_index])  # Attaque l'ennemi correspondant à l'index
    when "x" then exit  # Quitte le jeu
    else
    puts "\n\e[30m\e[47mTu passes ton tour...\e[0m\n"  # Affiche que le joueur passe son tour
    end
    @enemies_in_sight.each do |e|
    kill_player(e) if e.life_points <= 0  # Vérifie si des ennemis ont été éliminés
    end
  end

  def enemies_in_sight_attack
    puts "\n\e[5m\e[1m\e[35mLes autres joueurs t'attaquent !" if @enemies_in_sight.any? { _1.life_points > 0 }
    sleep 0.5
    @enemies_in_sight.each{ _1.attacks(@human_player) if _1.life_points > 0 }  # Les ennemis attaquent le joueur humain s'ils sont encore en vie
  end

  def end
    puts "\nLa partie est finie"  # Affiche que la partie est terminée
    if @human_player.life_points > 0
    puts "\n\e[30m\e[42mBRAVO ! TU AS GAGNE !\n"  # Affiche un message de victoire si le joueur humain est encore en vie
    else
    puts "\n\e[30m\e[41mLoser ! Tu as perdu !\n"  # Affiche un message de défaite si le joueur humain est mort
    end
  end
end