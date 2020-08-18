extends Area2D

var invencible = false setget set_invincible
onready var timer = $Timer
onready var collision = $CollisionShape2D

signal invencibility_started
signal invincibility_ended
	
func set_invincible(value):
	invencible = value
	if invencible: emit_signal("invencibility_started")
	else: emit_signal("invincibility_ended")

func start_invencibility(duration):
	self.invencible = true
	timer.start(duration)
	
func _ready():
	pass
	
func _on_Timer_timeout():
	self.invencible = false

func _on_HurtBox_invencibility_started():
	collision.set_deferred("disabled", true)

func _on_HurtBox_invincibility_ended():
	collision.disabled = false
