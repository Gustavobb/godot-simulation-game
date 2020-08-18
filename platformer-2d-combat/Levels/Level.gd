extends Node2D

onready var text = $CanvasLayer/Text
export(int) var enemies = 0

func _ready():
	pass

func _on_PlayerMapDetection_player_entered(page, _level):
	text.display_text(page)

func _on_EndMap_player_entered(_page, level):
	PlayerStats.level = level
	GameData.save(PlayerStats.health, PlayerStats.level)
	SceneChange.change_scene("res://Levels/Level%s.tscn"%str(level))

func _on_Enemy_enemie_died():
	enemies -= 1
	if not enemies: $YSort/Platforms/EndMapPlatform.queue_free()

func _on_Player_player_died():
	SceneChange.change_scene("res://Levels/DeathScreen/DeathScreen.tscn")
