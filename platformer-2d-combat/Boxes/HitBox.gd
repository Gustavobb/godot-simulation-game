extends Area2D

export var damage = 1

func _ready():
	pass

func _process(_delta):
	pass

func _on_Boundries_area_entered(_area):
	SceneChange.change_scene("res://Levels/%s.tscn"%str(get_tree().get_current_scene().get_name()))
