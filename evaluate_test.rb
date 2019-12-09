#!/usr/bin/env ruby
require './evaluate.rb'
require "test/unit/assertions"
include Test::Unit::Assertions

def test_is_flush
	assert is_flush("C12 C13 C14 C11 C10")
	assert !is_flush("H12 C12 S12 D12 H10")
end

def test_is_straight
	assert is_straight("C1 C2 C3 C4 C5")
	assert !is_straight("C1 C2 C3 C5 C6")
end

def test_is_full_house
	assert is_full_house("C1 H1 C2 H2 D2")
	assert is_full_house("C1 H1 D1 C2 H2")
	assert !is_full_house("C1 C2 C3 C4 C5")
end

def test_is_four_of_a_kind
	assert is_four_of_a_kind("C1 H1 D1 S1 S2")
	assert is_four_of_a_kind("C1 H2 D2 S2 C2")
	assert !is_four_of_a_kind("C1 C2 C3 C4 C5")
end

def test_is_three_of_a_kind
	assert is_three_of_a_kind("C1 H1 D1 S3 S2")
	assert is_three_of_a_kind("C1 H2 D2 S2 C3")
	assert is_three_of_a_kind("C1 C2 H5 D5 C5")
	assert !is_three_of_a_kind("C1 C2 C3 C4 C5")
end

def test_is_two_pair
	assert is_two_pair("C1 H1 C2 H2 S2")
	assert is_two_pair("S2 H1 C1 H2 S2")
	assert is_two_pair("C1 H1 H2 S2 C5")
	assert !is_two_pair("C1 C2 C3 C4 C5")
end

def test_is_one_pair
	assert is_one_pair("C1 H1 C2 C3 C4")
	assert is_one_pair("C1 H1 C2 C3 C4")
	assert is_one_pair("S2 H1 C1 C3 C4")
	assert is_one_pair("C1 H4 H2 S2 C5")
	assert is_one_pair("C1 H4 H2 S5 C5")
	assert !is_one_pair("C1 C2 C3 C4 C5")
end

def test_get_high_card
	assert get_high_card("H1 H2 H12 H5") == 12
	assert get_high_card("C1 H1 D1 S1") == 1
	assert get_high_card("C2 H2 D2 S2") == 2
end

def test_evaluate_hand
	assert evaluate_hand("C10 C11 C12 C13 C14") == 914
	assert evaluate_hand("C1 H1 C2 H2 D2") == 702
	assert evaluate_hand("H1 D1 C1 S1 C2") == 801
	assert evaluate_hand("H1 H3 H6 H7 H9") == 609
	assert evaluate_hand("H1 C2 C3 D4 S5") == 505
	assert evaluate_hand("H1 C1 D1 C10 D12") == 401
	assert evaluate_hand("H10 C1 H2 C2 D1") == 302
	assert evaluate_hand("H10 C10 H1 H2 H13") == 210
	assert evaluate_hand("H1 D12 S14 H5 C6") == 14
end

def test_evaluate_hands
	hands = [
		"C10 C11", "C1 H1", "H1 D1",
		"H1 H3", "H1 C2", "H1 C1",
		"H10 C1", "H10 C10","H1 D12"
	]
	assert evaluate_hands(hands, "C12 C13 C14") == 0
	hands = [
		"C10 D11", "C1 H1", "H1 D2",
		"H1 H3", "H1 C2", "H1 C2",
		"H10 C1", "H10 C10","H1 D12"
	]
	assert evaluate_hands(hands, "C12 C9 C14") == 1
end

test_is_flush
test_is_straight
test_is_full_house
test_is_four_of_a_kind
test_is_three_of_a_kind
test_is_two_pair
test_evaluate_hand
test_evaluate_hands