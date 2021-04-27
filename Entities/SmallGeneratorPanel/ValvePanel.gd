extends Spatial

onready var button_audio := $"Control Panel 3/ButtonAudio"
onready var valve_audio := $"ValveAudio"
onready var motor_audio := $"MotorDisabled"
export (AudioStreamSample) var sample = null
export (AudioStreamSample) var sample2 = null
var valves_closed = false

func _on_KinematicBody_object_interacted():
	var players = get_tree().get_nodes_in_group("player")
	if players:
		if players[0].has_control_panel_key:
			if not valves_closed:
				valve_audio.play()
				$"Control Panel 3/KinematicBody".interacted = false
				yield(valve_audio, "finished")
				valves_closed = true
			else:
				motor_audio.play()
		else:
			var radios = get_tree().get_nodes_in_group("radio")
			if radios:
				radios[0].pending_signal(sample)
				
			button_audio.play()


func _on_MotorDisabled_finished():
	var radios = get_tree().get_nodes_in_group("radio")
	if radios:
		radios[0].pending_signal(sample2)
