# frozen_string_literal: true

require 'English'

# Classe représentant un joueur
class Player
  attr_accessor :name, :life_points

  def initialize(name)
    @name = name
    @life_points = 10
  end

  def show_state
    puts "#{@name} a \e[1m\e[32m#{@life_points} point(s) de vie\e[0m"
  end

  def gets_damage(damage)
    @life_points = [@life_points - damage, 0].max
    puts "\n\e[41m\e[30mLe joueur #{@name} a été tué !\e[0m" if @life_points.zero?
  end

  def compute_damage
    rand(1..6) # Calcule les dégâts aléatoires entre 1 et 6
  end

  def attacks(other_player)
    damage = compute_damage
    return unless other_player.life_points.positive?

    puts "\n\e[33m\e[1m#{@name}\e[31m inflige #{damage} point(s) de dommages à \e[33m#{other_player.name}\e[0m"
    other_player.gets_damage(damage)
    sleep 0.5
  end
end

# La classe HumanPlayer hérite de la classe Player.
# Elle représente un joueur humain dans le jeu.
class HumanPlayer < Player
  attr_accessor :weapon_level

  def initialize(name)
    super(name)
    @life_points = 100
    @weapon_level = 1
  end

  def show_state
    puts "\nTu as \e[1m\e[32m#{@life_points} point(s) de vie\e[0m"
  end

  def compute_damage
    # Calcule les dégâts aléatoires multipliés par le niveau de l'arme du joueur
    rand(1..6) * @weapon_level
  end

  def search_weapon
    found_weapon_level = rand(1..6) # Génère un niveau d'arme aléatoire entre 1 et 6
    puts "\n\e[36mTu as trouvé une arme de niveau #{found_weapon_level}\e[0m"
    if found_weapon_level > @weapon_level
      @weapon_level = found_weapon_level
      puts "\n\e[32mYouhou ! elle est meilleure que ton arme actuelle : \e[1mtu la prends.\e[0m"
      sleep 0.5
    elsif found_weapon_level <= @weapon_level
      puts "\n\e[31m\e[1mM@*#{$INPUT_LINE_NUMBER}.. \e[0m\e[31melle n'est pas mieux que ton arme actuelle...\e[0m"
      sleep 0.5
    end
  end

  def search_health_pack
    dice = rand(1..6)
    case dice
    when 1 then puts "\nTu n'as rien trouvé"
    when 2..5 then heal_player(50, "\nBravo, tu as trouvé un pack de \e[32m+50 points de vie !\e[0m")
    when 6 then heal_player(80, "\nWaow, tu as trouvé un pack de \e[36m+80 points de vie !\e[0m")
    end
  end

  def heal_player(healing_points, message)
    @life_points = (@life_points + healing_points).clamp(0, 100)
    puts message
  end
end
