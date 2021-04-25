extends Spatial

func _on_Interactable_object_interacted():
	var labels = get_tree().get_nodes_in_group("informational_label")
	if labels:
		labels[0].display("You shut off the alarm")
		
	$OmniLight.light_energy = 0.0
