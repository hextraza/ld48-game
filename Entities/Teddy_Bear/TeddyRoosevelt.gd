extends Spatial

onready var bear_audio := $BearAudio

func _on_KinematicBody_object_interacted():
	var labels = get_tree().get_nodes_in_group("informational_label")
	if labels:
		labels[0].display("Acquired the teddy bear")
	
	self.visible = false
	bear_audio.play()


func _on_BearAudio_finished():
	self.queue_free()
