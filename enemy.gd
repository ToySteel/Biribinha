extends CharacterBody2D

var direction := -1
const SPEED = 100.0
@onready var texture := $AnimatedSprite2D
@onready var wall_detector := $wall_detector
@onready var anim := $AnimatedSprite2D
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if wall_detector.is_colliding():
		direction *= -1
		wall_detector.scale.x *= -1
	if direction == 1:
		texture.flip_h = true
	else:
		texture.flip_h = false
	
	if direction -1:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	velocity.x = direction * SPEED 
	move_and_slide()
