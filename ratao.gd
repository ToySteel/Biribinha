extends CharacterBody2D

const BOMB := preload("res://bomb.tscn")
const MISSILE := preload("res://missile.tscn")
@export var direction := 1
const SPEED = 100.0
@onready var texture := $sprite
@onready var wall_detector := $wall_detec
@onready var attack_point_2: Marker2D = %attack_point2
@onready var attack_point_1: Marker2D = %attack_point1

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if wall_detector.is_colliding(): 
		direction *= -1
		wall_detector.scale.x *= -1
	if direction == 1:
		texture.flip_h = false
	else:
		texture.flip_h = true
	
	if direction -1:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	velocity.x = direction * SPEED 
	
	move_and_slide()
	
func throw_bomb():
	var bomb_instance = BOMB.instantiate()
	add_sibling(bomb_instance)
	bomb_instance.global_position = attack_point_1.global_position
	bomb_instance.apply_impulse(Vector2(randi_range(direction * 30, direction * 200), randi_range(-200,-400)))

func launch_missile():
	var missile_instance = MISSILE.instantiate
	add_sibling(missile_instance)
	missile_instance.global_position = attack_point_2.global_position

func _on_cooldown_timeout() -> void:
	throw_bomb()

func _on_missile_cooldown_timeout():
	launch_missile()
