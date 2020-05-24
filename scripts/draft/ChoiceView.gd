extends Control

class_name DraftSceneChoiceView

signal option_clicked(option_label)
signal option_animation_finished()

var timer : float
var buttons : Array
var number_options : int
var active : bool

var counter_label : Label
var choose_label : Label
var skew_container : VSkewBoxContainer
var header_animation : AnimationPlayer
var tween : Tween

var selected_button : DraftButton

func setup():
	timer = 10
	active = false
	tween = $Tween
	
	counter_label = $NodePathTracker.get_node_by_name("CounterLabel")
	choose_label = $NodePathTracker.get_node_by_name("ChooseLabel")
	skew_container = $NodePathTracker.get_node_by_name("ButtonsSkewContainer")
	header_animation = $NodePathTracker.get_node_by_name("HeaderAnimationPlayer")
	
	tween.connect("tween_all_completed", self, "_tween_all_completed")
	
	for button in skew_container.get_children():
		buttons.append(button)
		button.connect("pressed", self, "_on_button_pressed", [button])

func present():
	show()
	header_animation.play("header_show")
	active = true

func dismiss():
	hide()
	active = false

func set_title(title : String):
	choose_label.text = title

func set_labels(labels : Array):
	number_options = labels.size()
	for i in range(buttons.size()):
		if (i < labels.size()):
			buttons[i].show()
			buttons[i].button_text = labels[i]
		else:
			buttons[i].hide()
	_enter_labels_animation()

func _enter_labels_animation():
	var positions = skew_container._get_children_positions()
	
	for i in range(positions.size()):
		var child = skew_container.get_child(i)
		skew_container.fit_child_in_rect(child, positions[i])
		
		child.modulate.a = 1.0
		child.rect_position.x = positions[i].position.x + OS.get_screen_size().x
		
		tween.interpolate_property(child, ":rect_position:x", \
		child.rect_position.x + OS.get_screen_size().x,\
		positions[i].position.x, 0.5,Tween.TRANS_CUBIC,Tween.EASE_OUT, i*0.1)
	tween.start()

func _exit_labels_animation():
	var positions = skew_container._get_children_positions()
	for i in range(positions.size()):
		
		var child = skew_container.get_child(i)
		
		if (child != selected_button):
			tween.interpolate_property(child, ":rect_position:x", \
			child.rect_position.x,\
			child.rect_position.x - OS.get_screen_size().x, 0.5,Tween.TRANS_CUBIC,\
			Tween.EASE_OUT, i*0.1)
		else:
			tween.interpolate_property(child, ":rect_scale", Vector2.ONE, \
			Vector2.ZERO, 0.5, Tween.TRANS_CUBIC,Tween.EASE_IN, 0)
			tween.interpolate_property(child, ":rect_rotation", 0, \
			randf()*30 - 15, 0.5, Tween.TRANS_CUBIC,Tween.EASE_IN, 0)
			tween.interpolate_property(child, ":modulate:a", 1, \
			0, 0.5, Tween.TRANS_CUBIC,Tween.EASE_IN, 0)
	tween.start()

func _tween_all_completed():
	if selected_button != null:
		selected_button.rect_rotation = 0
		selected_button.rect_scale = Vector2.ONE
		selected_button.modulate.a = 1.0
		emit_signal("option_animation_finished")
		selected_button = null

func _process(delta):
	if not active: return
	
	timer -= delta
	counter_label.text = str(ceil(timer))
	if (timer < 0.0):
		_on_button_pressed(buttons[randi()%number_options])

func _on_button_pressed(button : Button):
	timer += 10
	selected_button = button
	emit_signal("option_clicked", selected_button.button_text)
	_exit_labels_animation()
