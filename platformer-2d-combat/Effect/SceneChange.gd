extends CanvasLayer

signal scene_changed()

onready var animation_player = $AnimationPlayer
onready var black = $Control/Black

func change_scene(path, delay = 0.5):
	yield(get_tree().create_timer(delay), "timeout")
	animation_player.play("Fade")
	yield(animation_player, "animation_finished")
	var result = get_tree().change_scene(path)
	assert(result == OK)
	animation_player.play_backwards("Fade")
	yield(animation_player, "animation_finished")
	emit_signal("scene_changed")
	
func _ready():
	pass
