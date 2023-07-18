require 'bundler'
Bundler.require

require_relative 'player'

class Game
  attr_accessor :human_player, :enemies

  def initialize(name)
    @human_player = HumanPlayer.new("#{name}")
    @enemies = Array.new(4) { |i| Player.new("Ennemi #{i+1}") }
  end

  def kill_player(player)
    @enemies.delete(player)
  end

  def is_still_ongoing?
    @human_player.life_points > 0 && @enemies.count > 0
  end

  def show_players
    @human_player.show_state
    sleep 1
    puts "\nIl y a \e[31m\e[1m#{@enemies.count} ennemis à tuer"
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
    @enemies.each.with_index do |e, i|
      puts "\e[30m\e[#{43+i}m#{i+1}\e[0m Attaquer Ennemi #{i+1} (#{e.life_points} points de vie)"
      i += 1
    end
    print "\n"
    #puts \e[30m\e[47mX\e[0m Quitter
  end

  def menu_choice(input)
    loop do
      case input
      when "a" then @human_player.search_weapon
      when "s" then @human_player.search_health_pack
      when "1" then @human_player.attacks(@enemies[0])
      when "2" then @human_player.attacks(@enemies[1])
      when "3" then @human_player.attacks(@enemies[2])
      when "4" then @human_player.attacks(@enemies[3])
      # when "x" then break
      else
        puts "\n\e[41m\e[30m\e[1mEntrée invalide.\e[0m"
        retry_flag = true
        menu
      end
    break unless retry_flag
    retry_flag = false
    @enemies.each { |e| kill_player(e) if e.life_points <= 0 }
    end
  end

  def enemies_attack
    puts "\n\e[5m\e[1m\e[35mLes autres joueurs t'attaquent !" if @enemies.any? { _1.life_points > 0 }
    sleep 1
    @enemies.each{ _1.attacks(@human_player) if _1.life_points > 0 }
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

