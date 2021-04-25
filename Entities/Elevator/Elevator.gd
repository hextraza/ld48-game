extends Spatial

export var new_player_position = Vector3(0, 0, 0)
onready var player = get_tree().get_root().get_node("World/Player")

func _on_Door_elevate():
	$AudioStreamPlayer.play()
	yield($AudioStreamPlayer, "finished")
	player.translation = new_player_position
