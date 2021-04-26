extends Spatial

enum DoorState {CLOSED, OPENING, OPEN, CLOSING, OCCUPIED}

onready var door_audio = $KinematicBody/AudioStreamPlayer3D
onready var elevator_audio = $KinematicBody/AudioStreamPlayer
onready var player = get_tree().get_root().get_node("World/Player")

var door_state = DoorState.CLOSED
var translate_vector = Vector3(0.0, 0.0, 0.0)
var max_translate_dist = 0
var translated_dist = 0

signal elevate
signal activate_control_panel

func _physics_process(delta):
	if door_state == DoorState.OPENING or door_state == DoorState.CLOSING:
		translate_vector.x = max_translate_dist * (delta/3.65)
		translated_dist += abs(translate_vector.x)
		self.translate(translate_vector)
		
	if door_state == DoorState.OPENING && translated_dist > abs(max_translate_dist):
		door_state = DoorState.OPEN
		translated_dist = 0
		emit_signal("activate_control_panel")
		door_audio.stop()
	elif door_state == DoorState.CLOSING && translated_dist > abs(max_translate_dist):
		door_state = DoorState.OCCUPIED
		translated_dist = 0
		player.start_screen_shake()
		emit_signal("elevate")

func _on_KinematicBody_object_interacted():
	if door_state == DoorState.CLOSED:
		door_state = DoorState.OPENING
		max_translate_dist = -2.5
		door_audio.play()

func _on_Control_Panel_object_interacted():
	if door_state == DoorState.OPEN:
		door_state = DoorState.CLOSING
		max_translate_dist = 2.5
		elevator_audio.play()
