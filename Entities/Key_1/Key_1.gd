extends Spatial

export(AudioStreamSample) var radio_sample
onready var audio := $AudioStreamPlayer
onready var teddy = get_tree().get_root().get_node("World/DamHall/Admin Room/Teddy/KinematicBody")

func _on_StaticBody_object_interacted():
	var players = get_tree().get_nodes_in_group("player")
	if players:
		players[0].has_office_key = true
		
	var labels = get_tree().get_nodes_in_group("informational_label")
	if labels:
		labels[0].display("Obtained Admin key")
	
	self.visible = false
	
	audio.play()


func _on_AudioStreamPlayer_finished():
	yield(get_tree().create_timer(4), "timeout")
	
	var radios = get_tree().get_nodes_in_group("radio")
	if radios:
		radios[0].pending_signal(radio_sample)
		yield(radios[0], "radio_finished")
		
	teddy.active = true
	
	self.queue_free()
