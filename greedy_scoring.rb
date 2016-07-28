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
  ## Get score method
  sum = 0
  total_valued_elements = 0
  (1..6).each do |i|
    dice_val_selected = dice.select {|dice_value| dice_value == i}

    if dice_val_selected.size >= 3
      sum += i==1 ? 1000 : i*100
      total_valued_elements += 3
    end

    remaining_elements = dice_val_selected.size % 3
    if remaining_elements > 0 and (i==1 or i==5)
      total_valued_elements+=remaining_elements
      sum += remaining_elements * 100   if i == 1
      sum += remaining_elements *  50   if i == 5
    end
  end
  [5 - total_valued_elements,sum]
end

puts 'Enter number of players : '
num_players = gets
num_players = num_players.chomp.to_i
total_score = Hash.new(0)

while true do
  (1..num_players).each do |player_id|
    player_rolls = roll(5)
    remaining_elements , roll_score = get_score(player_rolls)
    total_score[player_id] += roll_score
    puts "\nPlayer #{player_id} rolls: #{player_rolls}"
    puts "Score in this round: #{roll_score}"
    puts "Do you want to roll the non-scoring #{remaining_elements} dice? (y/n)"
    option_selected = gets

    if option_selected.chomp =='y'
      player_rolls = roll(remaining_elements)
      remaining_elements , roll_score = get_score(player_rolls)
      total_score[player_id] += roll_score
      puts "Player #{player_id} rolls: #{player_rolls}"
      puts "Score in this round: #{roll_score}"
    end
  end

  puts "Continue for another round (y/n)"
  option_selected = gets
  if option_selected.chomp =='n'
    puts "The End.. Calculating final score."
    break
  end
end

puts "Final Score"
total_score.each do |key, score|
  puts  "Player #{key} score: #{score}"
end
