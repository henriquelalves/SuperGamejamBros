extends HBoxContainer

var pivot : Control = null

func setup(option_text : String):
	$Label.text = option_text
	pivot = $Pivot
