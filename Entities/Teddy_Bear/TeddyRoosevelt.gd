extends Spatial

func _on_KinematicBody_object_interacted():
	var labels = get_tree().get_nodes_in_group("informational_label")
	if labels:
		labels[0].display("Acquired the teddy bear")
	self.queue_free()
