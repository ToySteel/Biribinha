extends Area2D

@onready var transition = $"../transition"
@export var next_level : String = "res://word_01.tscn"


func _on_body_entered(body):
	if body.name == "player" and !next_level == "":
		transition.change_scene(next_level)
	else:
		print("No scene loaded")
