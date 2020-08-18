extends AnimatedSprite

func _ready():
	frame = 0
	var _c = connect("animation_finished", self, "_on_animation_finished")
	play("Animation")
	
func _process(_delta):
	pass
	
func _on_animation_finished():
	queue_free()
