extends StaticBody2D

func _ready():
	$Sprite.frame = 0
	
func _process(_delta):
	pass
	
func _on_Area2D_body_entered(_body):
	$AudioStreamPlayer2D.play()
	$AnimationPlayer.play("Grow")

func _on_Area2D_body_exited(_body):
	$AudioStreamPlayer2D2.play()
	$AnimationPlayer.play("Shrink")
