extends Spatial

onready var control_area := get_parent().get_node("Voice11Area")

func _on_KinematicBody_object_interacted():
	var labels = get_tree().get_nodes_in_group("informational_label")
	if labels:
		labels[0].display("Turned off intake pipes")
	
	control_area.monitoring = true
