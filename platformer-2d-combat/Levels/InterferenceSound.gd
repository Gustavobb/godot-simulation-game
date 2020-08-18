extends AudioStreamPlayer2D

func _ready():
	play()

func _on_InterferenceSound_finished():
	play()
