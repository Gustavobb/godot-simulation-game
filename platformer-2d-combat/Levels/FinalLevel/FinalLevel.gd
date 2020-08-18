extends Node2D

onready var text = $CanvasLayer/Text
var stop = false

func _ready():
	pass
	
func _process(_delta):
	BackgroundMusic.stop_playing()
	if stop: 
		$YSort/Player.state = 1
		$YSort/Player.velocity.x = 0

func _on_PlayerMapDetection_player_entered(page, _level):
	$Stop.start()
	text.display_text(page)
	stop = true

func _on_Stop_timeout():
	stop = false
