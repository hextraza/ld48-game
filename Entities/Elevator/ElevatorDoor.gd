extends Spatial

enum DoorState {CLOSED, OPENING, OPEN, CLOSING, OCCUPIED}

onready var door_audio = $KinematicBody/AudioStreamPlayer3D
onready var elevator_audio = $KinematicBody/AudioStreamPlayer
onready var player = get_tree().get_root().get_node("World/Player")
onready var elevator = get_parent()

var door_state = DoorState.CLOSED
var translate_vector = Vector3(0.0, 0.0, 0.0)
var max_translate_dist = 0
var translated_dist = 0

signal elevate
signal activate_control_panel

func _physics_process(delta):
	if elevator != null && elevator.door_open:
		$KinematicBody.active = false
		$"../Control Panel".active = false
		_on_KinematicBody_object_interacted()
		
	if door_state == DoorState.OPENING or door_state == DoorState.CLOSING:
		translate_vector.x = 0.25 * (max_translate_dist * delta) # should take 4 secondsish
		translated_dist += abs(translate_vector.x)
		self.translate(translate_vector)
		
	if door_state == DoorState.OPENING && translated_dist > abs(max_translate_dist):
		door_state = DoorState.OPEN
		translated_dist = 0
		
		if !elevator.door_open:
			emit_signal("activate_control_panel")
			door_audio.stop()
		else:
			elevator.door_open = false
	elif door_state == DoorState.CLOSING && translated_dist > abs(max_translate_dist):
		door_state = DoorState.OCCUPIED
		translated_dist = 0
		
		player.start_screen_shake()
		player.input_disabled = false
		
		emit_signal("elevate")

func _on_KinematicBody_object_interacted():
	if door_state == DoorState.CLOSED:
		door_state = DoorState.OPENING
		max_translate_dist = -1.35
		
		if !elevator.door_open:
			door_audio.play()

func _on_Control_Panel_object_interacted():
	if door_state == DoorState.OPEN:
		door_state = DoorState.CLOSING
		max_translate_dist = 1.35
		elevator_audio.play()
		
		player.input_disabled = true
