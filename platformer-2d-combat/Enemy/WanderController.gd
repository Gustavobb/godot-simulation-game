extends Node2D

onready var num = 0
onready var wander_timer = $Timer
onready var wait_to_wander_timer = $Timer2

signal wander_timer_ended
signal wait_to_wander_timer_ended
	
func update_num():
	num = rand_range(-100 , 100)
	num = -1 if not num >= 0 else 1
	
func _ready():
	update_num()
	var wait_time = rand_range(3, 10)
	wait_to_wander_timer.start(wait_time)

func reestart_wait_timer_cause_need_to_do_something():
	wander_timer.start(0.15)
	
func _on_wait_to_wander_timer_timeout():
	update_num()
	emit_signal("wait_to_wander_timer_ended")
	
func _on_wander_timer_timeout():
	emit_signal("wander_timer_ended")
