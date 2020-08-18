extends Control

var max_hearts = 0 setget set_max_hearts
var hearts = max_hearts setget set_hearts

onready var heart_ui_full = $HearthFull
onready var heart_ui_empty = $HearthEmpty

func set_hearts(value):
	hearts = value
	if heart_ui_full: heart_ui_full.rect_size.x = hearts * 32
	
func set_max_hearts(value):
	max_hearts = value
	if heart_ui_empty: heart_ui_empty.rect_size.x = max_hearts * 32
	
func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	var _status = PlayerStats.connect("health_changed", self, "set_hearts")
	_status = PlayerStats.connect("max_health_changed", self, "set_max_hearts")
