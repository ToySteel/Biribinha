extends Control
@onready var timer_counter: Label = $container/timer_container/timer_counter as Label
@onready var life_counter: Label = $"container/life_container/life counter" as Label
@onready var clock_timer: Timer = $clock_timer as Timer
var minutes = 0
var seconds = 0 
@export_range(0,5) var default_minutes := 1
@export_range(0,59) var default_seconds := 0


func _ready() -> void:
	life_counter.text = str("%02d" % Globals.player_life)
	timer_counter.text = str("%02d" % default_minutes) + ":" + str("%02d" % default_seconds)
	
	





func _process(delta: float) -> void:
	life_counter.text = str("%02d" % Globals.player_life)


func _on_clock_timer_timeout() -> void:
	if seconds > 59:
		minutes +=1
		seconds = 0
	seconds += 1
	timer_counter.text = str("%02d" % minutes) + ":" + str("%02d" % seconds)
