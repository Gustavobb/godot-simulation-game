extends KinematicBody2D

var sig = 0
var velocity = Vector2.ZERO

func _ready():
	pass

func _process(delta):
	velocity = velocity.move_toward(20 * Vector2(0 ,sig), 20 * delta)
	velocity = move_and_slide(velocity)
	
func _on_Up_timeout():
	velocity.y = 0
	sig = -1
	$Down.start()

func _on_Down_timeout():
	velocity.y = 0
	sig = 1
	$Up.start()

func _on_Area2D_area_entered(_area):
	var _result = get_tree().change_scene("res://Levels/Credits/EndDialogue.tscn")

func _on_AudioStreamPlayer2D_finished():
	$AudioStreamPlayer2D.play()
