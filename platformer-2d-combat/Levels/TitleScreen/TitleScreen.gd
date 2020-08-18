extends Node

onready var new_game = $MarginContainer/VBoxContainer/VBoxContainer/NewGame
onready var quit = $MarginContainer/VBoxContainer/VBoxContainer/Quit
onready var continue_ = $MarginContainer/VBoxContainer/VBoxContainer/Continue
onready var text = $RichTextLabel
onready var sound = $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/Volume
var mute = false

func _ready():
	continue_.grab_focus()
	text.set_bbcode("[center] Warn: To continue you must have achieved at least level 6.[/center]")
	
func _on_NewGame_pressed():
	$Select.play()
	PlayerStats.health = PlayerStats.max_health
	PlayerStats.level = 1
	GameData.save(PlayerStats.health, PlayerStats.level)
	SceneChange.change_scene("res://Levels/Level1.tscn")

func _on_Quit_pressed():
	$Select.play()
	get_tree().quit()
	
func _on_Continue_pressed():
	$Select.play()
	GameData._load()
	if PlayerStats.level >= 6: SceneChange.change_scene("res://Levels/Level6.tscn")
	else: text.set_bbcode("[center][color=red] Warn: To continue you must have achieved at least level 6.[/color][/center]")

func _on_TextureButton_focus_exited():
	$ChangeFocus.play()

func _on_AudioStreamPlayer_finished():
	$Interferecne.play()

func _on_Volume_pressed():
	$Select.play()
	mute = not mute
	if mute: AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	else: AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)  
