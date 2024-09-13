extends Control
@onready var label_special = $MarginContainer/HBoxContainer/VBoxContainer/label_special


# Called when the node enters the scene tree for the first time.
func _ready():
	label_special.text = str("%02d" % Globals.global_minutes) + ":" + str("%02d" % Globals.global_seconds)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_btn_pressed():
	get_tree().change_scene_to_file("res://word_00.tscn")
func _on_quit_btn_pressed() -> void:
	get_tree().quit()
