extends Area

export(AudioStreamSample) var sample = null
onready var intake_panel = get_parent().get_node("IntakePanel")
var entered = false

func _on_Area_body_entered(_body):
	if not entered:
		entered = true
		var radios = get_tree().get_nodes_in_group("radio")
		if radios:
			radios[0].pending_signal(sample)
			yield(radios[0], "radio_finished")
			
		intake_panel.get_node("Control Panel 2/KinematicBody").active = true
		queue_free()
