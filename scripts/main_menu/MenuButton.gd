extends Control

signal pressed

func _ready():
	$MenuButtonContainer.connect("gui_input", self, "_on_button_container_gui_input")
	
func _on_button_container_gui_input(ev : InputEvent):
	if ev is InputEventMouseButton and ev.is_pressed():
		emit_signal("pressed")
