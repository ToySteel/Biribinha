extends Area2D

signal Coca_refri

func _on_body_entered(body):
	get_node("Coca refri on").visible = false
	get_node("Coca refri off").visible = true
	emit_signal("Coca_refri")
	print("sinal coca")
	$Timer.start()

func _on_timer_timeout():
	get_node("Coca refri on").visible = true
	get_node("Coca refri off").visible = false
