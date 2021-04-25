extends Spatial

export var new_player_position = Vector3(0, 0, 0)
export var next_elevator_reference = ""
onready var next_elevator_door = get_tree().get_root().get_node(next_elevator_reference + "/Door")
onready var player = get_tree().get_root().get_node("World/Player")

func _on_Door_elevate():
	$AudioStreamPlayer.play()
	yield($AudioStreamPlayer, "finished")
	player.translation = new_player_position
	
	var t = Timer.new()
	t.set_wait_time(0.5)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()

	next_elevator_door.open()
