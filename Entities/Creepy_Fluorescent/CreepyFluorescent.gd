extends SpotLight

export var flickering = false
export(float) var flicker_intensity = 1.0
onready var audio = $AudioStreamPlayer3D
var rng = RandomNumberGenerator.new()
var time_to_flicker = 0.5
var next_attenuation_val = 0.5
var acc = 0
var turning_off = false

onready var backlight = $SpotLight

func _ready():
	rng.randomize()
	audio.play()

func _process(delta):
	if flickering == true:
		acc += delta
		
		if acc >= time_to_flicker:
			if turning_off:
				if next_attenuation_val == -1:
					next_attenuation_val = 0.02
					time_to_flicker = 0.2 / flicker_intensity
				elif next_attenuation_val == 0.02:
					next_attenuation_val = 1
					time_to_flicker = 0.1 / flicker_intensity
					audio.stream_paused = true
				elif next_attenuation_val == 1:
					next_attenuation_val = 0.01
					time_to_flicker = 0.2 / flicker_intensity
					audio.stream_paused = false
				elif next_attenuation_val == 0.01:
					next_attenuation_val = 2
					time_to_flicker = 0.1 / flicker_intensity
					audio.stream_paused = true
				elif next_attenuation_val == 2:
					next_attenuation_val = 300
					time_to_flicker = 5 / flicker_intensity
				elif next_attenuation_val == 300:
					next_attenuation_val = rng.randf_range(0.5, 0.7)
					time_to_flicker = rng.randf_range(0.1, 0.2)
					turning_off = false
					audio.stream_paused = false
			else:
				time_to_flicker = rng.randf_range(0.01, 0.2)
				next_attenuation_val = rng.randf_range(0.01, 2)
			
				var flicker_roll = rng.randi_range(0, 200)
			
				if flicker_roll > 160:
					time_to_flicker += 0.9
					next_attenuation_val = 0.01
				elif flicker_roll < 3:
					turning_off = true
					next_attenuation_val = -1
					time_to_flicker = -1
				else:
					time_to_flicker = rng.randf_range(0.01, 0.1)
			
			self.spot_attenuation = next_attenuation_val * flicker_intensity
			backlight.omni_attenuation = next_attenuation_val * flicker_intensity
			acc = 0
