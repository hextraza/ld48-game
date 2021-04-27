extends Spatial

onready var button_audio := $"Control Panel 3/ButtonAudio"
onready var valve_audio := $ValveAudio

func _on_KinematicBody_object_interacted():
	var labels = get_tree().get_nodes_in_group("informational_label")
	if labels:
		labels[0].display("Disabled Motors")
		
	button_audio.play()
	
	yield(get_tree().create_timer(1.0), "timeout")
	
	valve_audio.play()
