extends PathFollow

export(float) var raising_speed := 0.0
onready var radio_pending_noise := $RadioPendingNoise
onready var radio_white_noise := $RadioWhiteNoise
onready var radio_audio := $RadioAudio
var is_pending := false

# States
enum RadioStates {WAITING, RAISING, LISTENING, FINISHED, LOWERING}
var state: int = RadioStates.WAITING

# State transitions
func waiting() -> void:
	state = RadioStates.WAITING
	
func pending_signal(audio: AudioStreamSample) -> void:
	if audio:
		radio_audio.stream = audio
	is_pending = true
	radio_pending_noise.playing = true
	waiting()
	
func raising() -> void:
	state = RadioStates.RAISING
	
func lowering() -> void:
	radio_white_noise.playing = false
	radio_audio.playing = false
	state = RadioStates.LOWERING
	
func listening() -> void:
	radio_pending_noise.playing = false
	radio_white_noise.playing = true
	radio_audio.playing = true
	state = RadioStates.LISTENING

func finished() -> void:
	is_pending = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
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
			if not Input.is_action_pressed("player_radio"):
				lowering()
			
			if radio_audio.stream:
				if radio_audio.get_playback_position() >= radio_audio.stream.get_length() * 0.9:
					finished()
	


func _on_RadioAudio_finished():
	radio_audio.stream = null
