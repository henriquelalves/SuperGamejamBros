extends Control

signal start_pressed

func _input(event):
	if not visible: return
	
	if event is InputEventMouseButton:
		emit_signal("start_pressed")
	
	if event is InputEventKey and event.is_pressed():
		var key = event.scancode
		if key == KEY_ENTER or key == KEY_SPACE:
			emit_signal("start_pressed")
