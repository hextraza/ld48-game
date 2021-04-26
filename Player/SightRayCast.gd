extends RayCast

export(AudioStreamSample) var sample
export(AudioStreamSample) var pending_noise_sample
var previous_collision_object: Object = null
var interact_label: Label = null

# States
enum InteractableRay {LOOKING, FOUND}
var state = InteractableRay.LOOKING

onready var first_control_panel = get_tree().get_root().get_node("World/Dam/ElevatorOne/Control Panel")

# State transitions
func found() -> void:
	var radios = get_tree().get_nodes_in_group("radio")
	if radios:			
		radios[0].radio_pending_noise.stream = pending_noise_sample 
		radios[0].pending_signal(sample)
		yield(radios[0], "radio_finished")
		first_control_panel.active = true

	self.enabled = false

func _physics_process(_delta) -> void:
	match state:
		InteractableRay.LOOKING:
			if is_colliding():
				var _collision_object = get_collider()
				found()
		
