extends Spatial

onready var audio := $AudioStreamPlayer

func _on_StaticBody_object_interacted():
	var players = get_tree().get_nodes_in_group("players")
	if players:
		players[0].has_office_key = true
		
	var labels = get_tree().get_nodes_in_group("informational_label")
	if labels:
		labels[0].display("Obtained Admin Key")
	
	self.visible = false
	
	audio.play()


func _on_AudioStreamPlayer_finished():
	self.queue_free()
