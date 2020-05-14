tool
extends Container

class_name VSkewBoxContainer

export(bool) var centralize_visible setget set_centralize_visible
export(bool) var invert_orientation setget set_orientation
export(float) var children_width setget set_width
export(float) var separation setget set_separation

var child_rect : Rect2
export(bool) var enable_fit_children : bool = true

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

func _get_children_positions() -> Array:
	if (get_child_count() == 0): return []
	
	var positions = []
	
	var children_height = (rect_size.y - (separation * (get_child_count()-1))) / get_child_count()
	var total_offset = rect_size.x - children_width
	var x_offset = 0
	if (get_child_count()-1 > 0):
		x_offset = total_offset / (get_child_count()-1)
	
	var centralize_offset_y = 0
	var centralize_offset_x = 0
	
	if centralize_visible:
		var hidden_children = 0
		for child in get_children():
			if not child.visible:
				hidden_children += 1
		centralize_offset_y = children_height * hidden_children * 0.5 + (separation * hidden_children * 0.5)
		centralize_offset_x = x_offset * hidden_children * 0.5
	
	var visible_children = 0
	for i in range(get_children().size()):
		if (centralize_visible and not get_child(i).visible): 
			positions.append(Rect2())
			continue
		
		var index = i
		if (centralize_visible): index = visible_children
		
		var child = get_child(i)
		var x_position = centralize_offset_x + x_offset * index
		if (invert_orientation): x_position = total_offset - x_position
		
		positions.append(Rect2(x_position, centralize_offset_y + children_height * index + (separation * index), children_width, children_height))
		
		if (centralize_visible): visible_children += 1
	return positions

func _on_sort_children():
	if not enable_fit_children: return
	
	var positions = _get_children_positions()
	for i in range(positions.size()):
		fit_child_in_rect(get_child(i), positions[i])
