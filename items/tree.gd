extends StaticBody2D

# Settings!
# Spawnrate is the probability that an item is harvested.
var spawnrate = 0.5
# Seasons the item is active.
var seasonsActive = [0,1,2,3]
# Season textures.
var textures = {
	0: Game.tree0,
	1: Game.tree1,
	2: Game.tree2,
	3: Game.tree3
}
