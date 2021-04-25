extends Spatial

# States
enum DoorStates {WAITING, OPENING, OPENED, SLAMMING, SLAMMED}
var state: int = DoorStates.WAITING
export(float) var door_speed := 1.0
var rotated := 0.0

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
	state = DoorStates.OPENING

func _on_Area_body_entered(_body):
	if state == DoorStates.OPENED or state == DoorStates.OPENING:
		state = DoorStates.SLAMMING

