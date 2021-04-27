extends Area

export(AudioStreamSample) var sample = null
onready var generator_panel := get_parent().get_node("GeneratorPanel/Control Panel 3/KinematicBody")
var entered = false

func _on_Area_body_entered(_body):
	if not entered:
		entered = true
		var radios = get_tree().get_nodes_in_group("radio")
		if radios:
			radios[0].pending_signal(sample)
			yield(radios[0], "radio_finished")
		
		generator_panel.active = true
		queue_free()
