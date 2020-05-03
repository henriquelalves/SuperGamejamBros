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

func _ready():
	rect_global_position = get_center_pivot_position()

func _on_gui_input(event):
	if event is InputEventMouseButton:
		is_pressing = event.is_pressed()
		if (is_pressing):
			raise()
	
	if is_pressing and event is InputEventMouseMotion:
		rect_position += (event as InputEventMouseMotion).relative

func _process(delta):
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
