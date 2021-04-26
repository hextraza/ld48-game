extends ColorRect

export var disable_fadein = false
var fade_in_time = 5.4
var acc = 0.001
onready var player = get_tree().get_root().get_node("World/Player")

export(AudioStreamSample) var sample

func _ready():
	var radios = get_tree().get_nodes_in_group("radio")
	if radios:
		radios[0].pending_signal(sample)
		
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
			labels[0].display("Press RMB to open your radio")
			
		self.queue_free()
