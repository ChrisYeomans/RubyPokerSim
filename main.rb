require './evaluate.rb'
require "open3"

# Each program being simulated
# will give out an input dependant
# on what is happening
# Any misunderstood input will
# be interpreted as a fold.

# To start a round each program 
# will be given the input of their
# hand with standard format, i.e:
# H10 C1

# on each round of betting, if they
# are still playing they will be given
# how much they need to play to stay
# in the game
# They must then return a number,
# the amount they wish to bet. If this
# is lower then the amount they need to
# play it will be interpreted as a fold
# They may also output F is they wish to
# fold

# If a player has folded they will recieve
# no other input until the next round.

$HAND_ARRAY = []
$MOVE_ARRAY = []
$MOVE_MUTEX = Mutex.new
$BIG_BLIND_AMOUNT = 4
$SMALL_BLIND_AMOUNT = 2
$BIG_BLIND_PLAYER = 1
$SMALL_BLIND_PLAYER = 2
$CURRENT_PLAYER = 0
$CURRENT_BET_HIGH = 0
$ROUND_OVER = false
$MIDDLE_CARDS = []
$DECK = []
$STACK_ARRAY = []
$STACK_MUTEX = Mutex.new
$TURN_NO = 0
$BETTING_TURN_LIVE = false

def parse_move(move, player_num)
	if !!( move =~ /\A[-+]?[0-9]+\z/) do
		if move + $MOVE_ARRAY[player_num] = $CURRENT_BET_HIGH do
			return move.to_i
		elsif move + $MOVE_ARRAY[player_num] > $CURRENT_BET_HIGH do
			$CURRENT_BET_HIGH = move + $MOVE_ARRAY[player_num]
			return move.to_i
		else
			return "F"
		end
	else
		return "F"
	end
end

def not_sat(mv_arr)
    val = -1
    mv_arr.each do |i|
        if i == "F" do
            pass
        else
            if val == -1 do
                val = i
            elsif val != i do
                return false
            end      
        end  
    end
    return true
end

def player(compile_command, run_command, pl_n)
	# initialize basic variables
	player_num = pl_n
	alive = true
	folded = false

	# if compile command is an empty string it
	# wont try to compile it
	if not compile_command.empty?
		if not system(compile_command)
			return false
		end
	end

	# run program
	Open3.popen(run_command) do |i, o, e|
		i.puts "Starting Game"

		# round loop
		while true do
			if alive do
				# turn loop
				i.puts "New Round"
				i.puts "Your Stack Size: #{$STACK_ARRAY[player_num]}"
				i.puts "Big Blind: P#{$BIG_BLIND_PLAYER} #{$BIG_BLIND_AMOUNT}"
				i.puts "Small Blind: P#{$SMALL_BLIND_PLAYER} #{$SMALL_BLIND_AMOUNT}"
				$STACK_MUTEX.synchronise do
					if $BIG_BLIND_PLAYER == player_num do
						if $STACK_ARRAY[player_num] - $BIG_BLIND_AMOUNT <= 0 do
							# TODO: split pot
						else
							$STACK_ARRAY[player_num] -= $BIG_BLIND_AMOUNT
						end
					elsif $SMALL_BLIND_PLAYER == player_num do
						if $STACK_ARRAY[player_num] - $SMALL_BLIND_AMOUNT <= 0 do
							# TODO: split pot
						else
							$STACK_ARRAY[player_num] -= $SMALL_BLIND_AMOUNT
						end
					end
				end
				i.puts "Hand: #{HAND_ARRAY[player_num]}"
				4.times do |i|
					# only advance on a new round
					while $TURN_NO != i do
						sleep 0.2.seconds
					end
					puts "Middle Cards: #{$MIDDLE_CARDS.compact.join(' ')}"
					while not_sat($MOVE_ARRAY) do # TODO: make not_sat function
						i.puts "Current Player: P#{$CURRENT_PLAYER}"
						if $CURRENT_PLAYER == player_num do
							$MOVE_MUTEX.synchronise do
								$BETTING_TURN_LIVE = true
								if folded do
									move = "F"
								else
									move = parse_move(i.gets.chomp)
								end

								# check if player has enough to make bet
								# otherwise fold
								if move.is_a? Integer do
									if $STACK_ARRAY[player_num] - move < 0 do
										move = "F"
									end 
								end
								folded = move == "F"
								$MOVE_ARRAY[player_num] = move
								$BETTING_TURN_LIVE = false
							end
						else
							sleep 0.2.seconds
						end

						# hold everyoen while a player is making a bet
						while $BETTING_TURN_LIVE
							sleep 0.2.seconds
						end
					end
				end
				# end of round
				if $STACK_ARRAY[player_num] <= 0 do
					alive = false
					$MOVE_MUTEX.synchronise do
						$MOVE_ARRAY[player_num] = "D"
					end
				end
				i.puts $HAND_ARRAY.join(';')
				i.puts "Round Winner: #{evaluate_hands($HAND_ARRAY, $MIDDLE_CARDS)}"
			end
			folded = false
			# TODO: hold until all done
		end
	end
end
