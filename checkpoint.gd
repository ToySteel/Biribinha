extends Area2D
@onready var animation_checkpoint = $anim
var is_activate = false


func _on_body_entered(body: Node2D) -> void:
	if body.name != "player" or is_activate:
		return
	activate_checkpoint()

func activate_checkpoint():
	animation_checkpoint.play("raising")
	if animation_checkpoint.animation == "raising":
		animation_checkpoint.play("cheked")


	
