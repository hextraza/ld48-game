extends ColorRect

export var disable_fadein = false
var fade_in_time = 5
var acc = 0.001
onready var player = get_tree().get_root().get_node("World/Player")

func _process(delta):
	if disable_fadein:
		acc = fade_in_time
		
	acc += delta
	self.modulate = Color(0, 0, 0, fade_in_time - acc)

	if acc >= fade_in_time:
		player.input_disabled = false
		self.queue_free()
