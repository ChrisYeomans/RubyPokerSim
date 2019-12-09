require './evaluate.rb'

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
