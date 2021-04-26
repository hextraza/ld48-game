extends Spatial

export (NodePath) var next_elevator
export var door_open = false

onready var player = get_tree().get_root().get_node("World/Player")

func _on_Door_elevate():
	var next_ref = get_node(next_elevator)
	
	yield($Door/KinematicBody/AudioStreamPlayer, "finished")
	player.stop_screen_shake()
	player.global_transform.origin = next_ref.global_transform.origin
	
	var t = Timer.new()
	t.set_wait_time(0.5)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()

	next_ref.get_node("Door").open()
