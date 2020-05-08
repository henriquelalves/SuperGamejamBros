extends Button

var is_pressing : bool
var choices_data : int
var pivot_control : Control

signal left_top
signal left_bottom

func setup(pivot : Control, button_label : String):
	pivot_control = pivot
	text = button_label
	is_pressing = false
	connect("gui_input", self, "_on_gui_input")
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")

func _ready():
	rect_global_position = get_center_pivot_position()

func _on_mouse_entered():
	pivot_control.get_child(0).show()
	pivot_control.get_child(0).modulate.a = 0.5

func _on_mouse_exited():
	pivot_control.get_child(0).hide()

func _on_gui_input(event):
	if event is InputEventMouseButton:
		is_pressing = event.is_pressed()
		if (is_pressing):
			raise()
			pivot_control.get_child(0).modulate.a = 1.0
		else:
			pivot_control.get_child(0).modulate.a = 0.5
	
	if event is InputEventMouseMotion:
		if is_pressing:
			rect_position += (event as InputEventMouseMotion).relative

func _process(_delta):
	var rect_center_y = (rect_global_position - pivot_control.rect_global_position + (rect_size * 0.5)).y
	var parent_bottom = (pivot_control.rect_size).y
	var parent_top = 0
	
	if (is_pressing):
		if (rect_center_y > parent_bottom):
			emit_signal("left_bottom")
		elif (rect_center_y < parent_top):
			emit_signal("left_top")
	
	if not is_pressing:
		rect_global_position = lerp(rect_global_position, get_center_pivot_position(), 0.1)

func get_center_pivot_position() -> Vector2:
		var parent_center = pivot_control.rect_size * 0.5
		return pivot_control.rect_global_position + parent_center - (rect_size * 0.5)
