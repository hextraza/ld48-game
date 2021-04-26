extends Spatial

onready var audio = $AudioStreamPlayer3D
onready var ringing = $AudioStreamPlayer3D2
onready var admin_room_trigger = get_tree().get_root().get_node("World/DamHall/Admin Room/AdminRoomTrigger")

func _on_Interactable_object_interacted():
	var labels = get_tree().get_nodes_in_group("informational_label")
	if labels:
		labels[0].display("Disconnected the phone line")

	audio.play()
	ringing.stop()


func _on_AudioStreamPlayer3D_finished():
	admin_room_trigger.state = admin_room_trigger.trigger_states.CREEPY


func _on_Teddy_teddy_acquired():
	ringing.play()
	
	yield(get_tree().create_timer(8.0), "timeout")
	
	ringing.stop()
