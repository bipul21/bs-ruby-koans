# Greed is a dice game where you roll up to five dice to accumulate
# points.  The following "score" function will be used to calculate the
# score of a single roll of the dice.
#
# A greed roll is scored as follows:
#
# * A set of three ones is 1000 points
#
# * A set of three numbers (other than ones) is worth 100 times the
#   number. (e.g. three fives is 500 points).
#
# * A one (that is not part of a set of three) is worth 100 points.
#
# * A five (that is not part of a set of three) is worth 50 points.
#
# * Everything else is worth 0 points.
#
#
# Examples:
#
# score([1,1,1,5,1]) => 1150 points
# score([2,3,4,6,2]) => 0 points
# score([3,4,5,3,3]) => 350 points
# score([1,5,1,2,4]) => 250 points
#
# More scoring examples are given in the tests below:
#
# Your goal is to write the score method.


def roll(size)
  #Simple Roll that returns array of rolls based on number of elements asked to be returned
  #@size: Specify the number of rolls to be returned
  size.times.map {Random.rand(1..6)}
end

def get_score(dice)
  ## Generic score method
  ## Returns counts of non-scoring rolls and total score generated in the roll
  sum = 0
  total_valued_elements = 0
  (1..6).each do |i|
    dice_val_selected = dice.select {|dice_value| dice_value == i}

    if dice_val_selected.size >= 3
      sum += i==1 ? 1000 : i*100
      total_valued_elements += 3
    end

    remaining_elements = dice_val_selected.size % 3
    if remaining_elements > 0 && (i==1 || i==5)
      total_valued_elements+=remaining_elements
      sum += remaining_elements * 100   if i == 1
      sum += remaining_elements *  50   if i == 5
    end
  end
  [dice.size - total_valued_elements,sum]
end


class GreederDiceGame
  attr_accessor :num_players
  attr_accessor :total_score
  attr_accessor :is_final_round
  SCORE_THRESHOLD = 3000
  DICE_THROW_SIZE = 5
  def initialize(num_players)
    @total_score = Hash.new(0)
    @num_players = num_players
    @is_final_round = false
  end

  def play
    while true do
      (1..@num_players).each do |player_id|
        remaining_elements, roll_score = self.roll_dice_and_process player_id, DICE_THROW_SIZE, total_score

        if roll_score < 300 && @total_score[player_id] == roll_score
          puts "Player #{player_id} score in this round is less than 300. And is not in the game yet"
          ## Resetting total score
          @total_score[player_id] = 0
          next
        end


        if remaining_elements > 0
          puts "Do you want to roll remaining #{remaining_elements} dice? (y/n)"
          if gets.chomp =='y'
            remaining_elements, roll_score = self.roll_dice_and_process player_id,remaining_elements,total_score
          end
        end

        puts "\n"
      end
      self.print_total_score
      break if @is_final_round

      max_score = @total_score.values.max
      if max_score >= SCORE_THRESHOLD
        puts "\n==========  Entering final round =========\n"
        @is_final_round = true
      end
    end
    declare_winner
  end

  def print_total_score
    puts "\n=========== Score Board =============="
    puts "Player \tScore"
    @total_score.each do |player_id, score|
      puts  "#{player_id}\t#{score}"
    end
    puts "\n"
  end

  def declare_winner
    max_score = @total_score.values.max
    winner_player = @total_score.key(max_score)
    puts  "Player #{winner_player} wins with #{max_score} points"
  end

  def roll_dice_and_process(player_id, roll_count, total_score)
    player_rolls = roll(roll_count)
    remaining_elements , roll_score = get_score(player_rolls)
    total_score[player_id] += roll_score
    puts "Player #{player_id} rolls: #{player_rolls}"
    puts "Score: #{roll_score}"
    [remaining_elements,roll_score]
  end
end

begin
  puts 'Enter number of players : '
  num_players = gets.chomp.to_i
  greeders_game = GreederDiceGame.new(num_players)
  greeders_game.play
rescue Exception
  puts 'Some error occurred. Please restart'
end