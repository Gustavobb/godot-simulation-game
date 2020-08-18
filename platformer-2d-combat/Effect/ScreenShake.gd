extends Node

var amplitude = 0
var priority = 0
onready var camera = get_parent()
const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT

func start(dur = 0.2, freq = 1000, ampl = 3, prior = 0):
	if prior >= self.priority:
		self.priority = prior
		self.amplitude = ampl
		$Duration.wait_time = dur
		$Frequency.wait_time = 1 / float(freq)
		$Duration.start()
		$Frequency.start()
		
		_shake()
		
func _shake():
	var rand = Vector2()
	rand.x = rand_range(-amplitude, amplitude)
	rand.y = rand_range(-amplitude, amplitude)
	
	$ShakeTween.interpolate_property(camera, "offset", camera.offset, rand, $Frequency.wait_time, TRANS, EASE)
	$ShakeTween.start()

func reset():
	$ShakeTween.interpolate_property(camera, "offset", camera.offset, Vector2(), $Frequency.wait_time, TRANS, EASE)
	$ShakeTween.start()
	
	priority = 0
	
func _ready():
	pass
	
func _on_Frequency_timeout():
	_shake()

func _on_Duration_timeout():
	reset()
	$Frequency.stop()
