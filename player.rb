class Player
  OPPOSITE_DIRECTIONS = {:forward => :backward, :backward => :forward, :left => :right, :right => :left}
  MAX_HEALTH = 20
  def play_turn(warrior)
    @warrior = warrior
    direction = warrior.direction_of_stairs
    space = warrior.feel direction
    calculate_resting_mode

    if need_resting?
      puts "I need to rest"      
      if in_safe_space?
        puts "Here is a nice place to rest"
        @resting_mode = true
        warrior.rest!
      else
        puts "I'll look for a safe place to rest"
        walk_in_safe_direction
      end
      return
    end
    if space.enemy?      
      warrior.attack! direction
    else
      walk direction
    end
  end
  
  def calculate_resting_mode
    @resting_mode = false if @warrior.health == MAX_HEALTH
  end
  
  def need_resting?
    @resting_mode || @warrior.health < 10
  end

  def in_safe_space?
    enemy = [:forward, :backward, :left, :right].find {|direction| @warrior.feel(direction).enemy?}
    enemy.nil?
  end
  
  def walk_in_safe_direction
    last_move = @walk_trace.pop
    @warrior.walk! OPPOSITE_DIRECTIONS[last_move]    
  end
  
  def walk direction
    @walk_trace ||= []
    @walk_trace << direction
    @warrior.walk! direction
  end
  
end
