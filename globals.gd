extends Node

var global_minutes = 0
var global_seconds = 0

var player_life := 3

var player = null

var current_checkpoint = null

func respawn_player():
	if current_checkpoint != null:
		player.global_position = current_checkpoint.global_position
