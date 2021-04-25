extends Spatial

var waiting := true
var translate_vector := Vector3(0.0, -3.0, 0.0)

func _physics_process(delta):
	if waiting == false:
		self.translate(translate_vector * delta)

func _on_KinematicBody_object_interacted():
	waiting = false
