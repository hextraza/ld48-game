extends PathFollow

export(float) var raising_speed := 0.0

# States
enum RadioStates {WAITING, PENDING_SIGNAL, RAISING, LISTENING, LOWERING}
var state: int = RadioStates.WAITING

# State transitions
func waiting():
	state = RadioStates.WAITING
	
func raising():
	state = RadioStates.RAISING
	
func lowering():
	state = RadioStates.LOWERING
	
func listening():
	state = RadioStates.LISTENING

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		RadioStates.WAITING:
			if Input.is_action_pressed("player_radio"):
				raising()
				
		RadioStates.RAISING:
			if Input.is_action_pressed("player_radio"):
				offset += raising_speed * delta
				if unit_offset >= 1.00:
					listening()
			else:
				lowering()
				
		RadioStates.LOWERING:
			if Input.is_action_pressed("player_radio"):
				raising()
			else:
				offset -= raising_speed * delta
				if unit_offset <= 0.00:
					waiting()
					
		RadioStates.LISTENING:
			if not Input.is_action_pressed("player_radio"):
				lowering()
	
