extends Control

var pivot : Control = null

func setup(option_text : String):
	$HBoxContainer/Label.text = option_text
	pivot = $HBoxContainer/Pivot
