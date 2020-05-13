tool
extends Light2D

func _process(delta):
	if not Engine.editor_hint: return
	
	var parent = get_parent() as Control
	if (parent == null): return

	var parent_size = parent.rect_size
	var texture_size = texture.get_size()
	scale = Vector2((parent_size.x+2) / texture_size.x, (parent_size.y+2) / texture_size.y)
	position = Vector2(floor(parent_size.x/2),floor(parent_size.y/2))
