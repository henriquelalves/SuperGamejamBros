tool
extends Button

class_name DraftButton

export(String) var button_text setget set_button_text

func set_button_text(value : String):
	button_text = value
	$ShortLabel.text = value
	
	_refresh_label()

func _refresh_label():
	var font : Font = $ShortLabel.get("custom_fonts/font")
	var max_width = $ControlLabelSize.rect_size.x
	font.set("size", 50)
	while (font.get_string_size(button_text).x > max_width &&\
	font.get("size") > 26):
		font.set("size", font.get("size") - 2)

func _on_resized():
	rect_pivot_offset = rect_size/2
	_refresh_label()

func _ready():
	connect("resized", self, "_on_resized")
	_on_resized()
