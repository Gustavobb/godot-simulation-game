extends Control

onready var play = $MarginContainer/VBoxContainer/TextureButton
onready var quit = $MarginContainer/VBoxContainer/TextureButton2
onready var sound = $MarginContainer/VBoxContainer/HBoxContainer/TextureButton3
var mute = false

func _ready():
	visible = false

func _input(event):
	if event.is_action_pressed("ui_esc"):
		$Select.play()
		play.grab_focus()
		get_tree().paused = not get_tree().paused
		visible = not visible
	
func _on_TextureButton_pressed():
	$Select.play()
	get_tree().paused = not get_tree().paused
	visible = not visible

func _on_TextureButton2_pressed():
	$Select.play()
	GameData.save(PlayerStats.health, PlayerStats.level)
	SceneChange.change_scene("res://Levels/TitleScreen/TitleScreen.tscn")
	get_tree().paused = not get_tree().paused
	visible = not visible

func _on_TextureButton_focus_exited():
	$ChangeFocus.play()

func _on_TextureButton3_pressed():
	$Select.play()
	mute = not mute
	if mute: 
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)  
