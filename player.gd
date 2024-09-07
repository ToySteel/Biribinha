extends CharacterBody2D
#VARIAVEIS GERAIS
# Variáveis básicas
const SPEED = 150.0
const JUMP_FORCE = -400.0
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
@onready var animationAgua := $animAgua
@onready var animationSprite := $animSprite
@onready var animationCoca := $animCola
#variaveis de animaçao
var animIdle = "idle Watter"
var animJump = "jump Watter"
var animRum = "run watter"

# Ghosting
@onready var ghost_scene = preload("res://sprite_2d.tscn")
var ghost_timer = 0.01  # Tempo entre fantasmas
var time_since_last_ghost = 0

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
		get_node("animAgua").visible = false
		get_node("animSprite").visible = false
		get_node("animCola").visible = false
		get_node("DashCola").visible = true
		emit_signal("Bug_fixer")
		can_dash = false
	########################################################
	# Movimento normal
	direction = Input.get_axis("ui_left", "ui_right")
	if !dashing:
		if direction != 0:
			animationAgua.scale.x = direction
			animationSprite.scale.x = direction
			animationCoca.scale.x = direction
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	############################################################
	_set_state()
	move_and_slide()
#voltar a estado inicial
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
#garafa de sprite
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
	get_node("animAgua").visible = false
	get_node("animSprite").visible = false
	get_node("animCola").visible = true
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
		
	if animationAgua.name != state:
		animationAgua.play(state)
	if animationSprite.name != state:
		animationSprite.play(state)
	if animationCoca.name != state:
		animationCoca.play(state)
#quando o dash acabar
func _on_dash_timer_timeout():
	dashing = false
	velocity.x = dash_direction * 0
	get_node("animAgua").visible = true
	get_node("animSprite").visible = false
	get_node("animCola").visible = false
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
