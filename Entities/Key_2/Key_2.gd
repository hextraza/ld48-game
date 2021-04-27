extends Spatial

onready var audio := $AudioStreamPlayer
onready var generator_panel := get_parent().get_node("GeneratorPanel/Control Panel 3/KinematicBody")
export(AudioStreamSample) var sample = null

func _on_StaticBody_object_interacted():
	var players = get_tree().get_nodes_in_group("player")
	if players:
		players[0].has_control_panel_key = true
		
	var labels = get_tree().get_nodes_in_group("informational_label")
	if labels:
		labels[0].display("Obtained Control Panel key")
	
	self.visible = false
	
	audio.play()
	
	var radios = get_tree().get_nodes_in_group("radio")
	if radios:
		radios[0].pending_signal(sample)
		
	generator_panel.interacted = false


func _on_AudioStreamPlayer_finished():
	self.queue_free()
