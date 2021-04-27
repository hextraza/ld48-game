extends Spatial

# States
enum DoorStates {WAITING, OPENING, OPENED, SLAMMING, SLAMMED}
var state: int = DoorStates.WAITING
export(float) var door_speed := 1.0
var rotated := 0.0
onready var open_audio := $"Generic Door/DoorOpenAudio"
onready var slam_audio := $"Generic Door/DoorSlamAudio"
onready var door := $"Generic Door/KinematicBody"
onready var slam_area := get_parent().get_node("Area")

func _physics_process(delta):
	match state:
		DoorStates.OPENING:
			if rotated >= PI / 2:
				state = DoorStates.OPENED
			
			rotated += door_speed * delta
			rotate_y(door_speed * delta)
		DoorStates.SLAMMING:
			if rotated <= 0.0:
				state = DoorStates.SLAMMED
			
			rotated -= door_speed * delta * 4
			rotate_y(-door_speed * delta * 4)


func _on_KinematicBody_object_interacted():
	open_audio.play()
	if state != DoorStates.SLAMMING and state != DoorStates.SLAMMED:
		slam_area.monitoring = true
	state = DoorStates.OPENING

func _on_Area_body_entered(_body):
	yield(get_tree().create_timer(2.0), "timeout")
	open_audio.stop()
	slam_audio.play()
	if state != DoorStates.SLAMMING and state != DoorStates.SLAMMED:
		slam_area.queue_free()
	state = DoorStates.SLAMMING
	door.interacted = false

