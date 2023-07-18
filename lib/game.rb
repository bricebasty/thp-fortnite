require 'bundler'
Bundler.require

require_relative 'player'

class Game
  attr_accessor :human_player, :enemies_in_sight, :players_left
  def initialize(name)
    @human_player = HumanPlayer.new("#{name}")
    @enemies_in_sight = []
    @players_left = 10
  end

  def kill_player(player)
    @enemies_in_sight.delete(player)
    @players_left -= 1
  end

  def is_still_ongoing?
    @human_player.life_points > 0 && @players_left > 0
  end

  def new_players_in_sight
    new_players =  rand(1..6)
    if @enemies_in_sight.count != @players_left && @enemies_in_sight.length <= 10
      case new_players
      when 1
        puts "\n\e[36mAucun nouveau joueur adverse n'arrive\e[0m"
      when (2..4)
        @enemies_in_sight << Player.new("Joueur_#{rand(1000..9999)}")
        puts "\n\e[36m1 adversaire arrive\e[0m"
      when (5..6)
        2.times do
          break if @enemies_in_sight.length >= 10
          @enemies_in_sight << Player.new("Joueur_#{rand(1000..9999)}")
        end
        puts "\n\e[36m2 adversaires arrivent\e[0m"
      end
    else
      puts "\n\e[36mTous les joueurs sont déjà en vue\e[0m"
    end
  end

  def show_players
    @human_player.show_state
    sleep 0.5
    puts "\nIl y a \e[31m\e[1m#{@enemies_in_sight.count} ennemis à tuer"
  end

  def user_prompt
    print "\e[1m\e[33m> "
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
      color_code = (43 + i) % 4 + 43
      puts "\e[30m\e[#{color_code}m#{i+1}\e[0m Attaquer #{e.name} (#{e.life_points} points de vie)"
      i += 1
    end
    print "\n"
    puts "\e[30m\e[47mX\e[0m Quitter"
  end

  def menu_choice(input)
      case input
      when "a" then @human_player.search_weapon
      when "s" then @human_player.search_health_pack
      when *("1".."10").to_a
        enemy_index = input.to_i - 1
        @human_player.attacks(@enemies_in_sight[enemy_index])
      when "x" then exit
      else
        puts "\n\e[30m\e[47mTu passes ton tour...\e[0m\n"
      end
    @enemies_in_sight.each do |e|
      kill_player(e) if e.life_points <= 0
    end
  end

  def enemies_in_sight_attack
    puts "\n\e[5m\e[1m\e[35mLes autres joueurs t'attaquent !" if @enemies_in_sight.any? { _1.life_points > 0 }
    sleep 0.5
    @enemies_in_sight.each{ _1.attacks(@human_player) if _1.life_points > 0 }
  end

  def end
    puts "\nLa partie est finie"
    if @human_player.life_points > 0
      puts "\n\e[30m\e[42mBRAVO ! TU AS GAGNE !\n"
    else
      puts "\n\e[30m\e[41mLoser ! Tu as perdu !\n"
    end
  end
end

