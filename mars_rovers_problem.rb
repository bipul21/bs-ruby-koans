MAP_SIZE = 5

DIRECTION_MAP = {:N => 0, :E => 1, :S => 2, :W => 3}
MAP_SIZE_X = 5
MAP_SIZE_Y = 5


class Rover
  attr_accessor :pos_x
  attr_accessor :pos_y
  attr_accessor :direction

  def initialize(pos_x,pos_y,direction)
    @pos_x = pos_x
    @pos_y = pos_y
    @direction = DIRECTION_MAP[direction.to_sym]
  end

  def move()
    if @direction == 0 && @pos_y != MAP_SIZE_Y
      @pos_y  += 1
    elsif @direction == 1 && @pos_x != MAP_SIZE_X
      @pos_x += 1
    elsif @direction == 2 && @pos_y != 0
      @pos_y -= 1
    elsif @direction == 3 && @pos_x != 0
      @pos_x -= 1
    end
  end

  def change_direction(direction)
    if direction == 'L'
      @direction = (@direction - 1) % 4
    elsif direction == 'R'
      @direction = (@direction + 1) % 4
    end
  end

  def apply(action)
    if action ==  'L' || action == 'R'
      self.change_direction(action)
    else
      self.move
    end
    # puts "#{action}, #{@pos_x}, #{@pos_y}, #{DIRECTION_MAP.key(@direction)}"
  #
  end

  def get_pos
    puts "#{@pos_x}, #{@pos_y}, #{DIRECTION_MAP.key(@direction)}"
  end
end



MAP_SIZE_X,MAP_SIZE_Y = gets.chomp.split(" ").map(&:to_i)

2.times do |i|
  pos_x, pos_y, direction = gets.chomp.split(" ")
  actions = gets.chomp
  rover = Rover.new(pos_x.to_i, pos_y.to_i, direction)
  actions.split('').each do |char|
    rover.apply char
  end
  puts rover.get_pos
end