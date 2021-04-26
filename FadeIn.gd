extends ColorRect

export var disable_fadein = false
var fade_in_time = 5.4
var acc = 0.001
onready var player = get_tree().get_root().get_node("World/Player")
onready var sight_ray_cast = player.get_node("Rotation_Helper/Camera/SightRayCast")
onready var radio = get_tree().get_nodes_in_group("radio")[0]

export(AudioStreamSample) var sample

func _ready():
	radio.pending_signal(sample)
	
	yield(radio, "radio_finished")
	yield(get_tree().create_timer(2.0), "timeout")
	
	sight_ray_cast.enabled = true
	self.queue_free()
	
func _process(delta):
	if disable_fadein:
		acc = fade_in_time
		
	acc += delta
	self.modulate = Color(0, 0, 0, fade_in_time - acc)

	if acc >= fade_in_time:
		player.input_disabled = false
		yield(get_tree().create_timer(1.9), "timeout")
		
		var labels = get_tree().get_nodes_in_group("informational_label")
		if labels:
			labels[0].display("Press RMB to open your radio", 6)
		
		visible = false
