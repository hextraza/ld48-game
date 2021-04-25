extends Spatial

func _on_Interactable_object_interacted():
	var labels = get_tree().get_nodes_in_group("informational_label")
	if labels:
		labels[0].display("Disconnected the phone line")
