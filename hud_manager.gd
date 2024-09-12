extends Control
@onready var timer_counter: Label = $container/timer_container/timer_counter as Label
@onready var life_counter: Label = $"container/life_container/life counter" as Label



func _ready() -> void:
	life_counter.text = str("%02d" % Globals.player_life)
	
	
	





func _process(delta: float) -> void:
	life_counter.text = str("%02d" % Globals.player_life)
