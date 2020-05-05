tool
extends Container

class_name VSkewBoxContainer

export(bool) var centralize_visible setget set_centralize_visible
export(bool) var invert_orientation setget set_orientation
export(float) var children_width setget set_width
export(float) var separation setget set_separation

var child_rect : Rect2

func set_centralize_visible(value):
	centralize_visible = value
	emit_signal("sort_children")

func set_orientation(value):
	invert_orientation = value
	emit_signal("sort_children")

func set_width(value):
	children_width = value
	emit_signal("sort_children")

func set_separation(value):
	separation = value
	emit_signal("sort_children")

func _ready():
	connect("sort_children", self, "_on_sort_children")

func _on_sort_children():
	if (get_child_count() == 0): return
	
	var children_height = (rect_size.y - (separation * (get_child_count()-1))) / get_child_count()
	var total_offset = rect_size.x - children_width
	var x_offset = total_offset / (get_child_count()-1)
	
	var centralize_offset_y = 0
	var centralize_offset_x = 0
	
	if centralize_visible:
		var hidden_children = 0
		for child in get_children():
			if not child.visible:
				hidden_children += 1
		centralize_offset_y = children_height * hidden_children * 0.5 + separation * hidden_children
		centralize_offset_x = x_offset * hidden_children * 0.5
	
	var visible_children = 0
	for i in range(get_children().size()):
		if (centralize_visible and not get_child(i).visible): continue
		
		var index = i
		if (centralize_visible): index = visible_children
		
		var child = get_child(i)
		var x_position = centralize_offset_x + x_offset * index
		if (invert_orientation): x_position = total_offset - x_position
		
		fit_child_in_rect(child, Rect2(x_position, centralize_offset_y + children_height * index + (separation * index), children_width, children_height))
		
		if (centralize_visible): visible_children += 1
