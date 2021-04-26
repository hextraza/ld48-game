extends Area

export(AudioStreamSample) var sample = null
var entered = false

func _on_Area_body_entered(_body):
	if not entered:
		entered = true
		var radios = get_tree().get_nodes_in_group("radio")
		if radios:
			radios[0].pending_signal(sample)
			yield(radios[0], "radio_finished")
			
		queue_free()
