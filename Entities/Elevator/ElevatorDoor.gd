extends Spatial

enum DoorState {CLOSED, OPENING, OPEN, CLOSING, OCCUPIED}

var door_state = DoorState.CLOSED
var translate_vector = Vector3(0.0, 0.0, 0.0)
var max_translate_dist = 0
var translated_dist = 0

signal elevate

func _physics_process(delta):
	if door_state == DoorState.OPENING or door_state == DoorState.CLOSING:
		translate_vector.x = max_translate_dist * delta
		translated_dist += abs(translate_vector.x)
		self.translate(translate_vector)
		
	if door_state == DoorState.OPENING && translated_dist > abs(max_translate_dist):
		door_state = DoorState.OPEN
		translated_dist = 0
	elif door_state == DoorState.CLOSING && translated_dist > abs(max_translate_dist):
		door_state = DoorState.OCCUPIED
		translated_dist = 0
		emit_signal("elevate")

func _on_KinematicBody_object_interacted():
	if door_state == DoorState.CLOSED:
		door_state = DoorState.OPENING
		max_translate_dist = -2.5

func _on_Control_Panel_object_interacted():
	if door_state == DoorState.OPEN:
		door_state = DoorState.CLOSING
		max_translate_dist = 2.5
