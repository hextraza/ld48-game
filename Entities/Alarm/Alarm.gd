extends Spatial

onready var alarm_audio = $Alarm_Player
onready var switch_audio = $Alarm_Switch
onready var light = $OmniLight
var acc = 0
var increment_acc = true

func _ready():
	alarm_audio.play()

func _physics_process(delta):
	if light.light_energy > 0:
		if increment_acc:
			acc += delta
		else:
			acc -= delta
		
		if acc >= 0.8:
			increment_acc = false
		elif acc <= 0.01:
			increment_acc = true
	
		light.light_energy = 4 * clamp(acc, 0.01, 1.6)

func _on_Interactable_object_interacted():
	var labels = get_tree().get_nodes_in_group("informational_label")
	if labels:
		labels[0].display("You shut off the alarm")
		
	light.light_energy = 0.0
	alarm_audio.stop()
	switch_audio.play()
