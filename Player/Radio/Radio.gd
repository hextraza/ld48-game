extends PathFollow

# To make use of the radio clips, all you have to do is call pending_signal
# with the audio sample that you want to play. You can get the radio by calling
# get_tree().get_nodes_in_group("radio")

export(float) var raising_speed := 0.0
onready var radio_pending_noise := $RadioPendingNoise
onready var radio_white_noise := $RadioWhiteNoise
onready var radio_audio := $RadioAudio
onready var player = get_tree().get_root().get_node("World/Player")
var is_pending := false

signal radio_finished

# States
enum RadioStates {WAITING, RAISING, LISTENING, FINISHED, LOWERING}
var state: int = RadioStates.WAITING

# State transitions
func waiting() -> void:
	state = RadioStates.WAITING
	
func pending_signal(audio: AudioStreamSample) -> void:
	if audio:
		radio_audio.stream = audio
		
	match state:
		RadioStates.WAITING, RadioStates.RAISING, RadioStates.LOWERING:
			is_pending = true
			if not radio_pending_noise.playing:
				radio_pending_noise.play()
		RadioStates.LISTENING:
			is_pending = true
			listening()
	
func raising() -> void:
	state = RadioStates.RAISING
	
func lowering() -> void:
	radio_white_noise.stop()
	radio_audio.stop()
	state = RadioStates.LOWERING
	
func listening() -> void:
	radio_pending_noise.stop()
	radio_white_noise.play()
	radio_audio.play()
	state = RadioStates.LISTENING

func finished() -> void:
	radio_audio.stream = null
	is_pending = false
	emit_signal("radio_finished")
	state = RadioStates.LISTENING

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	if !player.input_disabled:
		_process_input(delta)
		
func _process_input(delta) -> void:
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
					if is_pending:
						pending_signal(null)
					else:
						waiting()
					
		RadioStates.LISTENING:
			if radio_audio.stream:
				if radio_audio.get_playback_position() >= radio_audio.stream.get_length():
					finished()
			else:
				if not Input.is_action_pressed("player_radio"):
					lowering()
