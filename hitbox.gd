extends Area2D
signal hurt
var teste
@onready var timer = $Timer
func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		body.velocity.y = body.JUMP_FORCE
		owner.anim.play("hurt")
		$Timer.start()
func _on_timer_timeout() -> void:
	owner.queue_free()