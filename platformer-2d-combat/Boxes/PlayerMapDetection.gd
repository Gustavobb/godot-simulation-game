extends Area2D

export(int) var level = 1
export(int) var page = 0

signal player_entered

func _ready():
	pass

func _on_PlayerMapDetection_body_entered(_body):
	emit_signal("player_entered", page, level)
	$CollisionShape2D.set_deferred("disabled", true)
