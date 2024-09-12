extends CharacterBody2D
#VARIAVEIS GERAIS
#Variáveis básicas
const SPEED = 150.0
const JUMP_FORCE = -400.0
#@export var player_life := 10
var knockback_vector := Vector2.ZERO
var direction
#Pulo duplo
var can_double_jump = false
var has_double_jumped = false
var is_jumping = false
#estados
var Sprite = false
var Cola = false
# Dash
const DASH_SPEED = 900.0
var dashing = false
var dash_direction = 0
var can_dash = false
#sinais
signal Bug_fixer
signal Agua_refri
#definiçao de animaçao em variaveis comuns de pasta
@onready var animation := $anim
#@onready var animationSprite := $animSprite
#@onready var animationCoca := $animCola
@onready var remote_transform := $remote
signal player_has_died()
#variaveis de animaçao
var animIdle = "idle Watter"
var animJump = "jump Watter"
var animRum = "run watter"
# Ghosting
@onready var ghost_scene = preload("res://sprite_2d.tscn")
var ghost_timer = 0.01  # Tempo entre fantasmas
var time_since_last_ghost = 0
#func _ready():
	#emit_signal("Agua_refri")
# Adiciona gravidade
func _physics_process(delta):
	# Aplica gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta
	################################################################
	# Reseta o pulo duplo ao tocar o chão
	if is_on_floor():
		if Sprite:
			can_double_jump = true
			has_double_jumped = false
	
	# Pulo simples e pulo duplo
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = JUMP_FORCE
		elif can_double_jump and !has_double_jumped:
			velocity.y = JUMP_FORCE
			has_double_jumped = true
			can_double_jump = false
			emit_signal("Agua_refri")
	#dash
	#########################################################
	# Direção do dash
	if Input.is_action_just_pressed("ui_left"):
		dash_direction = -1
	if Input.is_action_just_pressed("ui_right"):
		dash_direction = 1
	# Ativa o dash
	if Input.is_action_just_pressed("ui_dash") and can_dash:
		if Cola:
			dashing = true
			$dash_timer.start()
	#durante o dash
	if dashing:
		velocity.x = dash_direction * DASH_SPEED
		velocity.y = 0
		spawn_ghost(delta)
		get_node("anim").visible = false
		#get_node("animSprite").visible = false
		#get_node("animCola").visible = false
		get_node("DashCola").visible = true
		emit_signal("Bug_fixer")
		can_dash = false
	########################################################
	# Movimento normal
	direction = Input.get_axis("ui_left", "ui_right")
	if !dashing:
		if direction != 0:
			animation.scale.x = direction
			#animationSprite.scale.x = direction
			#animationCoca.scale.x = direction
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	############################################################
	
	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector
	
	
	_set_state()
	move_and_slide()
#voltar a estado inicial
func _on_agua_refri():
	Sprite = false
	Cola = false
	animIdle = "idle Watter"
	animJump = "jump Watter"
	animRum = "run watter"
	#get_node("anim").visible = true
	#get_node("animSprite").visible = false
	#get_node("animCola").visible = false
	print("troca")
#garafa de sprite
func _on_sprite_refri_sprite_refri():
	Sprite = true
	Cola = false
	animIdle = "Idle Sprite"
	animJump = "jump sprite"
	animRum = "Run Sprite"
	#get_node("anim").visible = false
	#get_node("animSprite").visible = true
	#get_node("animCola").visible = false
	can_double_jump = true
	has_double_jumped = false
	print("troca")
#garafa de coca
func _on_coca_refri_coca_refri():
	Sprite = false
	Cola = true
	can_dash = true
	has_double_jumped = true
	can_double_jump = false
	animIdle = "idle Cola"
	animJump = "Jump Cola"
	animRum = "run Cola"
	#get_node("anim").visible = true
	#get_node("animSprite").visible = false
	#get_node("animCola").visible = true
	print("troca")
#animaçoes legais
func _set_state():
	var state = animIdle
	if dashing:
		state = "dash cola"
	if !is_on_floor():
		state = animJump
	elif direction != 0:
		state = animRum
		
	if animation.name != state:
		animation.play(state)
	#if animationSprite.name != state:
		#animationSprite.play(state)
	#if animationCoca.name != state:
		#animationCoca.play(state)
#quando o dash acabar
func _on_dash_timer_timeout():
	dashing = false
	velocity.x = dash_direction * 0
	get_node("anim").visible = true
	#get_node("animSprite").visible = false
	#get_node("animCola").visible = false
	get_node("DashCola").visible = false
	emit_signal("Agua_refri")
	$dash_timer.stop()
# Método para criar fantasmas durante o dash
func spawn_ghost(delta):
	time_since_last_ghost += delta
	if time_since_last_ghost >= ghost_timer:
		# Instancia a cena do fantasma
		var ghost = ghost_scene.instantiate()
		ghost.position = position  # Define a posição do fantasma como a posição atual do personagem
		ghost.modulate.a = 0.5  # Define a opacidade inicial do fantasma
		
		# Adiciona o fantasma na cena
		get_parent().add_child(ghost)
		
		# Reseta o tempo
		time_since_last_ghost = 0


func _on_hurtbox_body_entered(body: Node2D) -> void:
	#if body.is_in_group("enemies"):
		#queue_free()
		if Globals.player_life <0:
			queue_free()
		else:
			if $ray_right.is_colliding():
				take_damage(Vector2(-200,-200))
			if $ray_left.is_colliding():
				take_damage(Vector2(200,-200))
func follow_camera(camera):
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path
func take_damage(knockback_force := Vector2.ZERO, duration := 0.25):
	if Globals.player_life >0:
		Globals.player_life -= 1
		if knockback_force != Vector2.ZERO:
			knockback_vector = knockback_force
			
			var knockback_tween := get_tree().create_tween()
			knockback_tween.tween_property(self, "knockback_vector", Vector2.ZERO, duration)
			animation.modulate = Color(1, 0.426, 0.357)
			knockback_tween.tween_property(animation, "modulate", Color(1, 1, 1, 1), duration)
	else:
		queue_free()
		emit_signal("Agua_refri")
		emit_signal("player_has_died")
		
