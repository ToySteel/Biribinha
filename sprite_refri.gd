extends Area2D

signal sprite_refri

func _on_body_entered(body):
	get_node("Sprite refri on").visible = false
	get_node("Sprite refri off").visible = true
	emit_signal("sprite_refri")
	print("sinal sprite")
	$Timer.start()

func _on_timer_timeout():
	get_node("Sprite refri on").visible = true
	get_node("Sprite refri off").visible = false
