extends Spatial


func _on_StaticBody_object_interacted():
	var players = get_tree().get_nodes_in_group("players")
	if players:
		players[0].has_office_key = true
	self.queue_free()
