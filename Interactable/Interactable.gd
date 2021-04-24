extends StaticBody

class_name Interactable
func get_class() -> String:
	return "Interactable"
	
# Signals
signal object_interacted
	
# Variables
var interacted := false
	
func interact() -> void:
	interacted = true
	emit_signal("object_interacted")
