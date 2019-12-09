def evaluate_hands(hands, middle_cards)
	# Will take in a list of hands
	# and return the index of the 
	# winning hand

	winning_index = 0
	winning_score = 0
	hands.each_with_index do |hand, i|
		rep_aces = hand.gsub(/(?<=[^0-9])1(?![CSDH0-9])/, '14')
		if rep_aces != hand
			hand_score = 0
			middle_cards.split.combination(3).each do |extra|
				ev = evaluate_hand(rep_aces + " " + extra.join(' '))
				if ev > hand_score
					hand_score = ev
				end
			end
			if hand_score > winning_score
				winning_index = i
				winning_score = hand_score
			end
		end
		hand_score = 0
		middle_cards.split.combination(3).each do |extra|
			ev = evaluate_hand(hand + " " + extra.join(' '))
			if ev > hand_score
				hand_score = ev
			end
		end
		if hand_score > winning_score
			winning_index = i
			winning_score = hand_score
		end
	end

	return winning_index
end

def evaluate_hand(hand)
	# returns a number dependant on how 
	# good the hand is
	# it is a 3 digit number
	# the first digit for the type of hand
	# the second 2 digits for the scale of the hand
	###############
	## List of hands in winning order:
	# straight-flush - 900
	# four-of-a-kind - 800
	# full-house - 700
	# flush - 600
	# straight - 500
	# three-of-a-kind - 400
	# two-pair - 300
	# one-pair - 200
	# high-card - worth
	##################
	# Current idea is to check for each
	# hand in winning order from the top.

	str = is_straight(hand)
	flush = is_flush(hand)
	four = is_four_of_a_kind(hand)
	house = is_full_house(hand)
	three = is_three_of_a_kind(hand)
	twop = is_two_pair(hand)
	one = is_one_pair(hand)

	if str and flush
		return 900 + get_high_card(flush)
	elsif four
		return 800 + get_high_card(four)
	elsif house
		return 700 + get_high_card(house)
	elsif flush
		return 600 + get_high_card(flush)
	elsif str
		return 500 + get_high_card(str)
	elsif three
		return 400 + get_high_card(three)
	elsif twop
		return 300 + get_high_card(twop)
	elsif one
		return 200 + get_high_card(one)
	else
		h = hand.split
		nm_lst = []
		h.each do |card|
			nm_lst << card[1..-1].to_i
		end
		return get_high_card(nm_lst)
	end
end

def is_flush(hand)
	h = hand.split
	suit = h[0][0]
	
	nm_lst = []
	h.each do |card|
		nm_lst << card[1..-1].to_i
	end

	h.each do |card|
		if card[0] != suit
			return false
		end
	end
	return nm_lst
end

def is_straight(hand)
	h = hand.split
	nm_lst = []
	h.each do |card|
		nm_lst << card[1..-1].to_i
	end
	nm_lst = nm_lst.sort

	if nm_lst[0] == nm_lst[-1] - 4
		return nm_lst
	else
		return false
	end
end

def is_full_house(hand)
	h = hand.split
	nm_lst = []
	h.each do |card|
		nm_lst << card[1..-1].to_i
	end
	nm_lst = nm_lst.sort

	if (nm_lst[0] == nm_lst[1]) and (nm_lst[2] == nm_lst[4])
		return nm_lst
	end
	if (nm_lst[0] == nm_lst[2]) and (nm_lst[3] == nm_lst[4])
		return nm_lst
	end
	return false
end

def is_four_of_a_kind(hand)
	h = hand.split
	nm_lst = []
	h.each do |card|
		nm_lst << card[1..-1].to_i
	end
	nm_lst = nm_lst.sort

	if (nm_lst[0] == nm_lst[3])
		return nm_lst[0..3]
	end
	if (nm_lst[1] == nm_lst[4])
		return nm_lst[1..4]
	end
	return false
end

def is_three_of_a_kind(hand)
	h = hand.split
	nm_lst = []
	h.each do |card|
		nm_lst << card[1..-1].to_i
	end
	nm_lst = nm_lst.sort

	if (nm_lst[0] == nm_lst[2])
		return nm_lst[0..2]
	end
	if (nm_lst[1] == nm_lst[3])
		return nm_lst[1..3]
	end
	if (nm_lst[2] == nm_lst[4])
		return nm_lst[2..4]
	end
	return false
end

def is_two_pair(hand)
	h = hand.split
	nm_lst = []
	h.each do |card|
		nm_lst << card[1..-1].to_i
	end
	nm_lst = nm_lst.sort

	if (nm_lst[0] == nm_lst[1]) and (nm_lst[2] == nm_lst[3])
		return [nm_lst[0], nm_lst[1], nm_lst[2], nm_lst[3]]
	end
	if (nm_lst[0] == nm_lst[1]) and (nm_lst[3] == nm_lst[4])
		return [nm_lst[0], nm_lst[1], nm_lst[3], nm_lst[4]]
	end
	if (nm_lst[1] == nm_lst[2]) and (nm_lst[3] == nm_lst[4])
		return [nm_lst[1], nm_lst[2], nm_lst[3], nm_lst[4]]
	end
	return false
end

def is_one_pair(hand)
	h = hand.split
	nm_lst = []
	h.each do |card|
		nm_lst << card[1..-1].to_i
	end
	nm_lst = nm_lst.sort

	if (nm_lst[0] == nm_lst[1])
		return [nm_lst[0], nm_lst[1]]
	end
	if (nm_lst[1] == nm_lst[2])
		return [nm_lst[1], nm_lst[2]]
	end
	if (nm_lst[2] == nm_lst[3])
		return [nm_lst[2], nm_lst[3]]
	end
	if (nm_lst[3] == nm_lst[4])
		return [nm_lst[3], nm_lst[4]]
	end
	return false
end

def get_high_card(num_cards)
	mx = 0
	num_cards.each do |card|
		card_num = card
		if card_num > mx
			mx = card_num
		end
	end
	return mx
end