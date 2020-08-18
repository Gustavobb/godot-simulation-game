extends Node

const SAVE_DIRECTORY = "user://saves/"
var save_path = SAVE_DIRECTORY + "save.dat"

func _ready():
	pass

func _load():
	var file = File.new()
	if file.file_exists(save_path):
		var return_ = file.open_encrypted_with_pass(save_path, File.READ, "my_wonderfull_game")
		if return_ == OK:
			var player_data = file.get_var()
			PlayerStats.health = player_data.health
			PlayerStats.level = player_data.level
			file.close()

		else: SceneChange.change_scene("res://Levels/TitleScreen/TitleScreen.tscn")
	
func save(health, level):
	var data = {
		"health": health,
		"level": level
	}
	
	var dir = Directory.new()
	if not dir.dir_exists(SAVE_DIRECTORY): dir.make_dir_recursive(SAVE_DIRECTORY)
	
	var file = File.new()
	var return_ = file.open_encrypted_with_pass(save_path, File.WRITE, "my_wonderfull_game")
	if return_ == OK: 
		file.store_var(data)
		file.close()
	else: SceneChange.change_scene("res://Levels/TitleScreen/TitleScreen.tscn")
