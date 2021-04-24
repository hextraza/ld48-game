extends RayCast

var previous_collision_object: Object = null
var interact_label: Label = null

# States
enum InteractableRay {WAITING, CAN_INTERACT, INTERACTED}
var state: int = InteractableRay.WAITING

# State transitions
func waiting() -> void:
	previous_collision_object = null
	interact_label.visible = false
	state = InteractableRay.WAITING
	
func can_interact(collision_object: Object) -> void:
	previous_collision_object = collision_object
	interact_label.visible = true	
	state = InteractableRay.CAN_INTERACT
	
func interacted() -> void:
	(previous_collision_object as Interactable).interact()
	interact_label.visible = false	
	state = InteractableRay.WAITING

# Functions
func _ready() -> void:
	var interact_labels = get_tree().get_nodes_in_group("interact_label")
	if interact_labels:
		interact_label = interact_labels[0]

func _physics_process(_delta) -> void:
	match state:
		InteractableRay.WAITING:
			if is_colliding():
				var collision_object = get_collider()
				if collision_object.get_class() == "Interactable" and (collision_object as Interactable).interacted == false:
					can_interact(collision_object)
					
		InteractableRay.CAN_INTERACT:
			if is_colliding():
				if get_collider() == previous_collision_object:
					if Input.is_action_pressed("player_interact"):
						interacted()
				else:
					waiting()
			else:
				waiting()
		
