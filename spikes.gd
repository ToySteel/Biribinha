extends Area2D
@onready var sprite_2d = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D



func _on_body_entered(body):
	if body.name == "player" && body.has_method("take_damage"):
		body.take_damage(Vector2(0, -250))
		
