extends Spatial

onready var alarm_audio = $Alarm_Player
onready var switch_audio = $Alarm_Switch
onready var interactable = $"Cable Box/Interactable"
onready var light = $OmniLight
onready var alarm_area = get_parent().get_node("AlarmArea")
onready var dam_voice = get_parent().get_node("DamVoice1")
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
	alarm_area.monitoring = true
		
	light.light_energy = 0.0
	alarm_audio.stop()
	switch_audio.play()


func _on_AlarmArea_body_entered(_body):
	interactable.disconnect("object_interacted", self, "_on_Interactable_object_interacted")
	interactable.connect("object_interacted", self, "_on_SecondInteractable_object_interacted")	
	interactable.active = true
	interactable.interacted = false
	
	light.light_energy = 4.0
	alarm_audio.play()
	alarm_area.queue_free()


func _on_SecondInteractable_object_interacted():
	var labels = get_tree().get_nodes_in_group("informational_label")
	if labels:
		labels[0].display("You shut off the alarm")
		
	light.light_energy = 0.0
	alarm_audio.stop()
	switch_audio.play()
	
	var tunnel_lights = get_tree().get_nodes_in_group("tunnel_lights")
	for tunnel_light in tunnel_lights:
		tunnel_light.light_energy = 0.0
		tunnel_light.get_parent().light_energy = 0.0
		tunnel_light.get_parent().get_node("AudioStreamPlayer3D").stop()
		
	yield(get_tree().create_timer(1.0), "timeout")
	dam_voice.play()

