extends Node2D
@onready var clock_timer: Timer = $HUD/control/clock_timer
@onready var player := $player
@onready var camera := $Camera
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.follow_camera(camera)
	player.player_has_died.connect(reload_game)
	Globals.player_life = 3



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reload_game():
	await get_tree().create_timer(1.0)
	get_tree().reload_current_scene()
