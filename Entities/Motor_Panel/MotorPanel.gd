extends Spatial

onready var button_audio = $"Control Panel 4/ButtonAudio"

func _on_KinematicBody_object_interacted():
	var labels = get_tree().get_nodes_in_group("informational_label")
	if labels:
		labels[0].display("Turned off motor")
	
	button_audio.play()
