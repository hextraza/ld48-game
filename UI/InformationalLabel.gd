extends Label

func display(text: String, duration: float = 3.0) -> void:
	self.text = text
	self.visible = true
	yield(get_tree().create_timer(duration), "timeout")
	self.visible = false
