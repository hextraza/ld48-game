extends Spatial

var waiting = true
var translate_vector = Vector3(0.0, 0.0, 0.0)
var max_translate_dist = -2.5
var translated_dist = 0

func _physics_process(delta):
	if waiting == false:
		translate_vector.x = max_translate_dist * delta
		translated_dist += abs(translate_vector.x)
		self.translate(translate_vector)
		
	if waiting == false && translated_dist > abs(max_translate_dist):
		waiting = true

func open():
	waiting = false
