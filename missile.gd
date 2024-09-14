extends AnimatableBody2D

const SPEED := 100.0
const EXPLOSION = preload("res://explosion.tscn")
@onready var sprite: Sprite2D = $sprite
@onready var collision_m: CollisionShape2D = $collision_m
@onready var collision_d: CollisionShape2D = $collision_detection/collision_d



var velocity := Vector2.ZERO
var direction

func _ready():
	set_direction(1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity.x = SPEED * direction * delta
	
	move_and_collide(velocity)

func set_direction(dir):
	direction = dir
	if direction == 1:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

func _on_collision_detection_body_entered(body: Node2D) -> void:
	visible = false
	var explosion_instance = EXPLOSION.instantiate()
	get_parent().add_child(explosion_instance)
	explosion_instance.global_position = global_position
	collision_m.set_deferred("disabled", true)
	collision_d.set_deferred("disabled", true)
	await explosion_instance.animation_finished
	queue_free()
