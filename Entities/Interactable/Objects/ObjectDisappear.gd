extends Spatial

func _on_StaticBody_object_interacted():
	self.queue_free()
