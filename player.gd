extends CharacterBody2D
#variaveis basicas
const SPEED = 150.0
const JUMP_FORCE = -400.0
#poderes
var can_double_jump = false 
var has_double_jumped = false
var can_dash = false
var direction
var is_jumping = false
var Sprite = false
var Cola = false
signal Agua_refri
@onready var animationAgua := $animAgua
@onready var animationSprite := $animSprite
@onready var animationCoca := $animCola
var animIdle = "idle Watter"
var animJump = "jump Watter"
var animRum = "run watter"

#adiciona gravidade
func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
	if is_on_floor():
		if Sprite:
			can_double_jump = true
			has_double_jumped = false  # Permite outro pulo duplo ao tocar o chão
	#pulo simples
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = JUMP_FORCE
		elif can_double_jump and !has_double_jumped:
			velocity.y = JUMP_FORCE
			has_double_jumped = true
			can_double_jump = false
			emit_signal("Agua_refri")
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("ui_left", "ui_right")
	if direction !=0:
		velocity.x = direction * SPEED
		animationAgua.scale.x = direction
		animationSprite.scale.x = direction
		animationCoca.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	_set_state()
	move_and_slide()
 
func _on_agua_refri():
	Sprite = false
	Cola = false
	animIdle = "idle Watter"
	animJump = "jump Watter"
	animRum = "run watter"
	get_node("animAgua").visible = true
	get_node("animSprite").visible = false
	get_node("animCola").visible = false
	print("troca")

func _on_sprite_refri_sprite_refri():
	Sprite = true
	Cola = false
	animIdle = "Idle Sprite"
	animJump = "jump sprite"
	animRum = "Run Sprite"
	get_node("animAgua").visible = false
	get_node("animSprite").visible = true
	get_node("animCola").visible = false
	can_double_jump = true
	has_double_jumped = false 
	print("troca")
	
func _on_coca_refri_coca_refri():
	Sprite = false
	Cola = true
	animIdle = "idle Cola"
	animJump = "Jump Cola"
	animRum = "run Cola"
	get_node("animAgua").visible = false
	get_node("animSprite").visible = false
	get_node("animCola").visible = true
	can_double_jump = false
	has_double_jumped = true
	print("troca")

func _set_state():
	var state = animIdle
	
	if !is_on_floor(): 
		state = animJump
	elif direction != 0:
		state = animRum
		
	if animationAgua.name != state:
		animationAgua.play(state)
	if animationSprite.name != state:
		animationSprite.play(state)
	if animationCoca.name != state:
		animationCoca.play(state)
