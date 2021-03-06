extends Spatial

var waiting = true
var translate_vector = Vector3(0.0, 0.0, 0.0)
var max_translate_dist = -1.35
var translated_dist = 0

onready var audio = $KinematicBody/AudioStreamPlayer

func _physics_process(delta):
	if waiting == false:
		translate_vector.x = 0.25 * (max_translate_dist * delta) # about 4 secondsish
		translated_dist += abs(translate_vector.x)
		self.translate(translate_vector)
		
	if waiting == false && translated_dist > abs(max_translate_dist):
		waiting = true
		audio.stop()

func open():
	waiting = false
	audio.play()
