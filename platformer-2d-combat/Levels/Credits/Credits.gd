extends Node

func _ready():
	BackgroundMusic.play()

func _input(event):
	if event.is_action_pressed("ui_esc"): SceneChange.change_scene("res://Levels/TitleScreen/TitleScreen.tscn")
