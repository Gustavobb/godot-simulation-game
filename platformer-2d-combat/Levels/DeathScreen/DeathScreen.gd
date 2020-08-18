extends Node

func _ready():
	if PlayerStats.level >= 6: GameData.save(PlayerStats.max_health, PlayerStats.level)

func _on_RebootTimer_timeout():
	SceneChange.change_scene("res://Levels/TitleScreen/TitleScreen.tscn")
