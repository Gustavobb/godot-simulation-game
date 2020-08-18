extends Node2D

export(int) var max_health = 0 setget set_max_health
var health = max_health setget set_health
var level = 1 setget set_level
signal out_of_health
signal health_changed(value)
signal max_health_changed(value)

func set_level(value):
	level = value
	
func set_health(value):
	health = value
	emit_signal("health_changed", health)
	health = clamp(value, 0, max_health)
	if not health: emit_signal("out_of_health")

func set_max_health(value):
	max_health = value
	if health > max_health: self.health = max_health
	max_health = max(value, 1)
	emit_signal("max_health_changed", max_health)
	
func _ready():
	self.health = max_health
	
func _process(_delta):
	pass
