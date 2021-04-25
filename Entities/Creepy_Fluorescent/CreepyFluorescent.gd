extends SpotLight

export var flickering = false
var rng = RandomNumberGenerator.new()
var time_to_flicker = 0.5
var next_attenuation_val = 0.5
var acc = 0
var turning_off = false

func _ready():
	rng.randomize()

func _process(delta):
	if flickering == true:
		acc += delta
		
		if acc >= time_to_flicker:
			if turning_off:
				if next_attenuation_val == -1:
					next_attenuation_val = 0.02
					time_to_flicker = 0.2
				elif next_attenuation_val == 0.02:
					next_attenuation_val = 1
					time_to_flicker = 0.1
				elif next_attenuation_val == 1:
					next_attenuation_val = 0.01
					time_to_flicker = 0.2
				elif next_attenuation_val == 0.01:
					next_attenuation_val = 2
					time_to_flicker = 0.1
				elif next_attenuation_val == 2:
					next_attenuation_val = 300
					time_to_flicker = 5
				elif next_attenuation_val == 300:
					next_attenuation_val = rng.randf_range(0.5, 0.7)
					time_to_flicker = rng.randf_range(0.1, 0.2)
					turning_off = false
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
					
				print(flicker_roll)
			
			self.spot_attenuation = next_attenuation_val
			acc = 0
