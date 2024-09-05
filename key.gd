extends Area2D

var door : NodePath
signal item_collected

func _on_body_entered(body):
	emit_signal("item_collected")
	queue_free()
