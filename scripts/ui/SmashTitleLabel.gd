tool
extends Control

class_name SmashLabel

export(String) var text_label setget set_text_label
export(Font) var inner_font
export(Material) var inner_font_material
export(int) var outline_size
export(Color) var outline_color

var out_font : Font
var letters : Array

func set_text_label(value : String):
	text_label = value
	if not Engine.editor_hint: return
	
	letters.clear()
	for child in get_children():
		child.queue_free()
	
	if (inner_font == null): return
	out_font = inner_font.duplicate()
	out_font.set("outline_size", outline_size)
	out_font.set("outline_color", outline_color)
	
	for l in value:
		var letter_label = Label.new()
		letter_label.text = l
		letter_label.set("custom_fonts/font", out_font)
		letters.append(letter_label)
		add_child(letter_label)
		letter_label.set_owner(get_tree().get_edited_scene_root())
		
		var inner_letter = letter_label.duplicate()
		inner_letter.set("custom_fonts/font", inner_font)
		inner_letter.set("material", inner_font_material)
		letter_label.add_child(inner_letter)
		inner_letter.set_owner(get_tree().get_edited_scene_root())
		
		letter_label.set("custom_colors/font_color_shadow", Color.black)
		letter_label.set("custom_constants/shadow_offset_x", 2)
		letter_label.set("custom_constants/shadow_offset_y", 8)
	
	yield(get_tree(), "idle_frame")
	
	var total_width = 0 
	for index in range(0, get_child_count()):
		var letter = get_child(index)
		letter.rect_pivot_offset.x = letter.rect_size.x/2
		letter.rect_pivot_offset.y = letter.rect_size.y/2
		letter.rect_rotation = -10 + randf() * 20
		total_width += letter.rect_size.x
		if (index > 0):
			var prev_letter = get_child(index-1)
			letter.rect_position.x = prev_letter.rect_position.x + prev_letter.rect_size.x
	rect_size.x = total_width

func _ready():
	letters = []
