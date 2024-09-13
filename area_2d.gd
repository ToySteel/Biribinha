extends Area2D



func _on_body_entered(body):
	print("entrou")
	get_tree().change_scene_to_file("res://World_02.tscn")
