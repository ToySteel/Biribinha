extends Node
#8=D
@onready var dialog_box_scene = preload("res://dialog_box.tscn")
var message_lines : Array[String] = []
var curent_line = 0

var dialog_box
var dialog_box_position := Vector2.ZERO

var is_message_active := false
var can_advance_mensage := false

func start_message(position: Vector2, lines: Array[String]):
	if is_message_active:
		return
	message_lines = lines
	dialog_box_position = position
	show_text()
	is_message_active = true

func show_text():
	dialog_box_scene.instantiate()
	dialog_box.text_display_finished.connect(_on_all_text_displayed)
	get_tree().root.add_child(dialog_box)
	dialog_box.global_position = dialog_box_position
	dialog_box.display_text(message_lines[curent_line])
	can_advance_mensage = false

func _on_all_text_displayed():
	can_advance_mensage = true

func _unhandled_input(event):
	if(event.is_action_pressed("message") && is_message_active && can_advance_mensage):
		dialog_box.queue_free()
		curent_line += 1
		if curent_line >= message_lines.size():
			is_message_active = false
			curent_line = 0 
			return
		show_text()
