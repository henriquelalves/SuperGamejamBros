extends Control

signal start_pressed

func _input(event):
	if not visible: return
	
	if event is InputEventMouseButton or event is InputEventKey:
		emit_signal("start_pressed")
