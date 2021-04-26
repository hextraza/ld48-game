extends Area

export(AudioStreamSample) var radio_sample1
export(AudioStreamSample) var radio_sample2
onready var key = get_tree().get_root().get_node("World/DamHall/Admin Room/Table/Key/Key 1/KinematicBody")
onready var teddy = get_tree().get_root().get_node("World/DamHall/Admin Room/Teddy/KinematicBody")
enum trigger_states {NONCREEPY, WAITING, CREEPY}
var state = trigger_states.NONCREEPY

func _on_AdminRoomTrigger_body_shape_entered(_body_id, _body, _body_shape, _local_shape):
	if state == trigger_states.NONCREEPY:
		state = trigger_states.WAITING
		var radios = get_tree().get_nodes_in_group("radio")
		if radios:
			radios[0].pending_signal(radio_sample1)
			yield(radios[0], "radio_finished")
			key.active = true
	elif state == trigger_states.WAITING:
		pass
	elif state == trigger_states.CREEPY:
		state = trigger_states.WAITING
		var radios = get_tree().get_nodes_in_group("radio")
		if radios:
			radios[0].pending_signal(radio_sample2)
			yield(radios[0], "radio_finished")
			teddy.active = true
		self.queue_free()
