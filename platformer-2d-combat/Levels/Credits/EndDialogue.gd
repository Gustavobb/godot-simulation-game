extends Node
var page = 32
var charac

func _ready():
	pass

func _process(_delta):
	BackgroundMusic.stop_playing()
	
func _on_ChangePhrase_timeout():
	$Text.display_text(page)
	$ChangePhrase.start(len($Text.dialog[page])/12.0)
	page += 1
	if page == 44: SceneChange.change_scene("res://Levels/Credits/Credits.tscn")
