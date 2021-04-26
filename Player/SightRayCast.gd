extends RayCast

export(AudioStreamSample) var sample
var previous_collision_object: Object = null
var interact_label: Label = null

# States
enum InteractableRay {LOOKING, FOUND}
var state = InteractableRay.LOOKING

# State transitions
func found() -> void:
	var radios = get_tree().get_nodes_in_group("radio")
	if radios:
		radios[0].pending_signal(sample)
	
	self.enabled = false

func _physics_process(_delta) -> void:
	match state:
		InteractableRay.LOOKING:
			if is_colliding():
				var _collision_object = get_collider()
				found()
		
