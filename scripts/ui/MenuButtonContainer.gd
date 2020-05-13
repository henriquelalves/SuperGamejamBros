extends Control

func _ready():
	connect("gui_input", self, "_on_gui_input")
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")

func _on_gui_input(ev : InputEvent):
	if ev is InputEventMouseButton and ev.is_pressed():
		_on_mouse_exited()

func _on_mouse_entered():
	$WhiteBackground.show()
	for child in $Mask.get_children():
		child.material.set_shader_param("invert", false)
	$AnimationPlayer.play("hover")

func _on_mouse_exited():
	$WhiteBackground.hide()
	for child in $Mask.get_children():
		child.material.set_shader_param("invert", true)
	$AnimationPlayer.play_backwards("hover")
