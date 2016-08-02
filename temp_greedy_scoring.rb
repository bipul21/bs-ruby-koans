# = Playing Greed
#
# Greed is a dice game played among 2 or more players, using 5
# six-sided dice.
#
# == Playing Greed
#
# Each player takes a turn consisting of one or more rolls of the dice.
# On the first roll of the game, a player rolls all five dice which are
# scored according to the following:
#
# Three 1's => 1000 points
# Three 6's =>  600 points
# Three 5's =>  500 points
# Three 4's =>  400 points
# Three 3's =>  300 points
# Three 2's =>  200 points
# One   1   =>  100 points
# One   5   =>   50 points
#
# A single die can only be counted once in each roll.  For example,
#                              a "5" can only count as part of a triplet (contributing to the 500
# points) or as a single 50 points, but not both in the same roll.
#
# Example Scoring
#
# Throw       Score
# ---------   ------------------
# 5 1 3 4 1   50 + 2 * 100 = 250
# 1 1 1 3 1   1000 + 100 = 1100
# 2 4 4 5 4   400 + 50 = 450
#
# The dice not contributing to the score are called the non-scoring
# dice.  "3" and "4" are non-scoring dice in the first example.  "3" is
# a non-scoring die in the second, and "2" is a non-score die in the
# final example.
#
# After a player rolls and the score is calculated, the scoring dice are
# removed and the player has the option of rolling again using only the
# non-scoring dice. If all of the thrown dice are scoring, then the
# player may roll all 5 dice in the next roll.
#
# The player may continue to roll as long as each roll scores points. If
# a roll has zero points, then the player loses not only their turn, but
# also accumulated score for that turn. If a player decides to stop
# rolling before rolling a zero-point roll, then the accumulated points
# for the turn is added to his total score.
#
#  == Getting "In The Game"
#
# Before a player is allowed to accumulate points, they must get at
# least 300 points in a single turn. Once they have achieved 300 points
# in a single turn, the points earned in that turn and each following
# turn will be counted toward their total score.
#
#    == End Game
#
# Once a player reaches 3000 (or more) points, the game enters the final
# round where each of the other players gets one more turn. The winner
# is the player with the highest score after the final round.
#
#    == References
#
# Greed is described on Wikipedia at
# http://en.wikipedia.org/wiki/Greed_(dice_game), however the rules are
# a bit different from the rules given here.


class GreedersGamer
  attr_accessor :total_score
  attr_accessor :num_players

  def initialize(num_players)
    @num_players = num_players
  end

end

def roll(size)
  #Simple Roll that returns array of rolls based on number of elements asked to be returned
  #@size: Specify the number of rolls to be returned
  size.times.map {Random.rand(1..6)}
end

def get_score(dice)
  ## Get score method
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

puts 'Enter number of players : '
num_players = gets.chomp.to_i
total_score = Hash.new(0)


## Helper method to roll and maintain and update dice roll scores
def roll_dice_and_process(player_id,roll_count,total_score)
  player_rolls = roll(roll_count)
  remaining_elements , roll_score = get_score(player_rolls)
  total_score[player_id] += roll_score
  puts "Player #{player_id} rolls: #{player_rolls}"
  puts "Score in this round: #{roll_score}"
  [remaining_elements,roll_score]
end

def print_total_score(total_score)
  puts "\n=========== Score Board =============="
  puts "Player \tScore"
  total_score.each do |player_id, score|
    puts  "#{player_id}\t#{score}"
  end
  puts "\n"
end

is_final_round = false
## Initializing Game
while true do
  (1..num_players).each do |player_id|
    remaining_elements, roll_score = roll_dice_and_process player_id, 5, total_score

    if roll_score <= 300 && total_score[player_id] == roll_score
      puts "Player #{player_id} score in this round is less than 300. And is not in the game yet"
      ## Resetting total score
      total_score[player_id] = 0
      next
    end

    while true do
      if remaining_elements == 0
        puts '******** You scored all 5 scoring dice. You get another full set of dice ******'
        remaining_elements = 5
      end

      puts "Do you want to roll remaining #{remaining_elements} dice? (y/n)"
      if gets.chomp =='y'
        remaining_elements, roll_score = roll_dice_and_process player_id,remaining_elements,total_score
      else
        break
      end
      if remaining_elements > 0
        break
      end
      puts "\n"
    end

  end
  print_total_score total_score


  total_score.each do |player_id, score|
    if score >= 3000
      if is_final_round
        break
      else
        puts "Player #{player_id} scored #{score}"
        puts '==========  Entering final round ========='
        is_final_round = true
      end
    end
  end
end
puts '=========== Final Score =============='
total_score.each do |player_id, score|
  puts  "Player #{player_id} score: #{score}"
end
