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
    puts "\n\e[41m\e[30mLe joueur #{@name} a été tué !\e[0m" if  @life_points == 0
  end

  def compute_damage
    rand(1..6) # Calcule les dégâts aléatoires entre 1 et 6
  end

  def attacks(other_player)
    damage = compute_damage
    if other_player.life_points > 0
      puts "\n\e[33m\e[1m#{@name}\e[31m attaque \e[33m#{other_player::name}\e[0m et lui inflige \e[31m\e[1m#{damage} point(s) de dommages\e[0m"
      other_player.gets_damage(damage)
      sleep 0.5
    end
  end
end

class HumanPlayer < Player
  attr_accessor :weapon_level

  def initialize(name)
    @name = name
    @life_points = 100
    @weapon_level = 1
  end

  def show_state
    puts "\nTu as \e[1m\e[32m#{@life_points} point(s) de vie\e[0m"
  end

  def compute_damage
    rand(1..6) * @weapon_level # Calcule les dégâts aléatoires multipliés par le niveau de l'arme du joueur
  end

  def search_weapon
    found_weapon_level = rand(1..6) # Génère un niveau d'arme aléatoire entre 1 et 6
    puts "\n\e[36mTu as trouvé une arme de niveau #{found_weapon_level}\e[0m"
    if found_weapon_level > @weapon_level
      @weapon_level = found_weapon_level
      puts "\n\e[32mYouhou ! elle est meilleure que ton arme actuelle : \e[1mtu la prends.\e[0m"
      sleep 0.5
    elsif found_weapon_level <= @weapon_level
      puts "\n\e[31m\e[1mM@*#$... \e[0m\e[31melle n'est pas mieux que ton arme actuelle...\e[0m"
      sleep 0.5
    end
  end

  def search_health_pack
    dice = rand(1..6) # Lance un dé aléatoire entre 1 et 6
    case dice
    when 1
      puts "\nTu n'as rien trouvé"
    when 2..5
      @life_points = (@life_points + 50).clamp(0, 100) # Ajoute 50 points de vie en s'assurant que la vie ne dépasse pas 100
      puts "\nBravo, tu as trouvé un pack de \e[32m+50 points de vie !\e[0m"
    when 6
      @life_points = (@life_points + 80).clamp(0, 100) # Ajoute 80 points de vie en s'assurant que la vie ne dépasse pas 100
      puts "\nWaow, tu as trouvé un pack de \e[36m+80 points de vie !\e[0m"
    end
  end
end
