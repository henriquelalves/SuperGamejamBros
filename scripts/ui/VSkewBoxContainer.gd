tool
extends Container

class_name VSkewBoxContainer

export(bool) var invert_orientation setget set_orientation
export(float) var children_width setget set_width

var child_rect : Rect2

func set_orientation(value):
	invert_orientation = value
	emit_signal("sort_children")

func set_width(value):
	children_width = value
	emit_signal("sort_children")

func _ready():
	connect("sort_children", self, "_on_sort_children")

func _on_sort_children():
	if (get_child_count() == 0): return
	
	var children_height = rect_size.y / get_child_count()
	var total_offset = rect_size.x - children_width
	var x_offset = total_offset / (get_child_count()-1)
	
	for i in range(get_children().size()):
		var child = get_child(i)
		var x_position = x_offset * i
		if (invert_orientation): x_position = total_offset - x_position
		
		fit_child_in_rect(child, Rect2(x_position, children_height * i, children_width, children_height))
