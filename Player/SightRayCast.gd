extends RayCast

var previous_collision_object: Object = null
var interact_label: Label = null

# States
enum InteractableRay {INACTIVE, LOOKING, FOUND}
export(InteractableRay) var state = InteractableRay.INACTIVE

# State transitions
func found() -> void:
	var labels = get_tree().get_nodes_in_group("informational_label")
	if labels:
		labels[0].display("Intake machine broke")
	self.enabled = false
	state = InteractableRay.INACTIVE

func _physics_process(_delta) -> void:
	match state:
		InteractableRay.LOOKING:
			if is_colliding():
				var _collision_object = get_collider()
				found()
		
