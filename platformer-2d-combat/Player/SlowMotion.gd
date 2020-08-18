extends Node

const END_VALUE = 1
var is_active = false
var time_start
var duration_ms
var start_value

func start(duration = 1.2, strenght = 0.9):
	time_start = OS.get_ticks_msec()
	duration_ms = duration * 1000
	start_value = 1 - strenght
	Engine.time_scale = start_value
	is_active = true
	
func _physics_process(_delta):
	if is_active:
		var current_time = OS.get_ticks_msec() - time_start
		var value = circl_ease_in(current_time, start_value, END_VALUE, duration_ms)
		if current_time >= duration_ms:
			is_active = false
			value = END_VALUE
			
		Engine.time_scale = value

func circl_ease_in(t, b, c, d):
	t /= d
	t -= 1
	return c * sqrt(1 - t * t) + b;
	
func _ready():
	Engine.time_scale = 1
