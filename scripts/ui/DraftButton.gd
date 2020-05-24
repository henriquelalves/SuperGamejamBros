tool
extends Button

class_name DraftButton

export(String) var button_text setget set_button_text

func set_button_text(value : String):
	button_text = value
	$ShortLabel.text = value
	$LongLabel.text = value
	
	_refresh_label()

func _refresh_label():
	var visible_short = $ShortLabel.get("custom_fonts/font").get_string_size(button_text).x < rect_size.x - 60
	$ShortLabel.visible = visible_short
	$LongLabel.visible = not visible_short

func _on_resized():
	rect_pivot_offset = rect_size/2
	_refresh_label()

func _ready():
	connect("resized", self, "_on_resized")
	_on_resized()
