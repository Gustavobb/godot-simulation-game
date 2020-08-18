extends AudioStreamPlayer
var play = true

func _ready():
	play()
	
func stop_playing():
	play = false
	stop()
	
func _on_BackgroundMusic_finished():
	if play: play()
