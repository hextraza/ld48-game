extends ColorRect

export var disable_fadein = false
var fade_in_time = 3
var acc = 0.0
var time_til_fade = 3.5
onready var player = get_tree().get_root().get_node("World/Player")
onready var sight_ray_cast = player.get_node("Rotation_Helper/Camera/SightRayCast")
onready var radio = get_tree().get_nodes_in_group("radio")[0]

export(AudioStreamSample) var sample

func _ready():
	radio.pending_signal(sample)
	
	yield(radio, "radio_finished")
	
	sight_ray_cast.enabled = true
	self.queue_free()
	
func _process(delta):
	if time_til_fade > 0:
		time_til_fade -= delta
		return
		
	if disable_fadein:
		time_til_fade = 0
		acc = fade_in_time

	acc += delta
	
	self.modulate = Color(0, 0, 0, clamp(1 - (acc/fade_in_time), 0, 1))

	if acc >= fade_in_time:
		player.input_disabled = false
		yield(get_tree().create_timer(1), "timeout")
		
		var labels = get_tree().get_nodes_in_group("informational_label")
		if labels:
			labels[0].display("Hold RMB to open your radio", 6)
		
		visible = false
