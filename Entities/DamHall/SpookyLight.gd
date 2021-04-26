extends Area

export(AudioStreamSample) var first_sample = null
export(AudioStreamSample) var second_sample = null
onready var alarm_door = get_parent().get_parent().get_node("AlarmDoor/RotationHelper/Generic Door/KinematicBody")
onready var alarm = get_parent().get_parent().get_node("Alarm/Cable Box/Interactable")
onready var light = get_parent()

func _on_Area_body_exited(_body):
	light.flickering = true
	monitoring = false
	yield(get_tree().create_timer(5.0), "timeout")
	light.flickering = false
	light.light_energy = 0.0
	light.get_node("SpotLight").light_energy = 0.0
	light.get_node("AudioStreamPlayer3D").stop()
	
	yield(get_tree().create_timer(2.0), "timeout")
	var radios = get_tree().get_nodes_in_group("radio")
	if radios:
		radios[0].pending_signal(first_sample)
		yield(radios[0], "radio_finished")
		
	yield(get_tree().create_timer(3.0), "timeout")
	if radios:
		radios[0].pending_signal(second_sample)
		yield(radios[0], "radio_finished")
	
	alarm_door.active = true
	alarm.active = true
		
	queue_free()
