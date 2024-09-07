extends Area2D

signal sprite_refri
signal Bug_fixer
var Bug_fixeer = false
func _on_body_entered(body):
	if !Bug_fixeer:
		get_node("Sprite refri on").visible = false
		get_node("Sprite refri off").visible = true
		emit_signal("sprite_refri")
		print("sinal sprite")
		$Timer.start()

func _on_timer_timeout():
	get_node("Sprite refri on").visible = true
	get_node("Sprite refri off").visible = false


func _on_player_bug_fixer():
	Bug_fixeer = true
	$Bug_Fixer.start()

func _on_bug_fixer_timeout():
	Bug_fixeer = false
	$Bug_Fixer.stop()
