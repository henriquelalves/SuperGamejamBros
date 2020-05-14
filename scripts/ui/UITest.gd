extends Control

var tween : Tween

func _ready():
	var positions = $Wallpaper/VSkewBoxContainer._get_children_positions()
	tween = Tween.new()
	add_child(tween)
	$Wallpaper/VSkewBoxContainer._on_sort_children()
	for i in range(positions.size()):
		
		var child = $Wallpaper/VSkewBoxContainer.get_child(i)
		child.rect_position.x += OS.get_screen_size().x
		
		tween.interpolate_property(child, ":rect_position:x", \
		child.rect_position.x + OS.get_screen_size().x,\
		positions[i].position.x, 0.4,Tween.TRANS_CUBIC,Tween.EASE_OUT, 1 + i*0.1)
	
	tween.start()
