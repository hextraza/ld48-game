extends KinematicBody

class_name Interactable
func get_class() -> String:
	return "Interactable"
	
# To create an interactable create a scene with a 3d model then add an instance 
# of the Interactable scene and fit the shape and area to the model roughly
# then create a script for the new scene and use the object_interacted signal to
# handle interaction events
	
# Signals
signal object_interacted
	
# Variables
var interacted := false
	
func interact() -> void:
	interacted = true
	emit_signal("object_interacted")
