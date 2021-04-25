extends Spatial

export(AudioStreamSample) var sample


func _on_KinematicBody_object_interacted():
	var radios = get_tree().get_nodes_in_group("radio")
	if radios:
		radios[0].pending_signal(sample)
	self.queue_free()
