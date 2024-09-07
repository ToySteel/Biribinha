extends Sprite2D

var fade_speed = 2.0  # Velocidade com que o fantasma vai desaparecer

func _ready():
	# Iniciar o processo de fade out
	set_process(true)

func _process(delta):
	# Reduzir a opacidade gradualmente
	modulate.a -= fade_speed * delta
	
	# Quando estiver completamente invisível, remover o fantasma
	if modulate.a <= 0:
		queue_free()
