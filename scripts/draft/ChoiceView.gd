extends Control

class_name DraftSceneChoiceView

signal option_clicked(option_label)

var timer : float
var buttons : Array
var number_options : int
var active : bool

func setup():
	timer = 10
	active = false
	
	for button in $VSkewBoxContainer.get_children():
		buttons.append(button)
		button.connect("pressed", self, "_on_button_pressed", [button])

func present():
	show()
	active = true

func dismiss():
	hide()
	active = false

func set_title(title : String):
	$ChooseLabel.text = title

func set_labels(labels : Array):
	number_options = labels.size()
	for i in range(buttons.size()):
		if (i < labels.size()):
			buttons[i].show()
			buttons[i].text = labels[i]
		else:
			buttons[i].hide()

func _process(delta):
	if not active: return
	
	timer -= delta
	$CounterLabel.text = str(ceil(timer))
	if (timer < 0.0):
		_on_button_pressed(buttons[randi()%number_options])

func _on_button_pressed(button : Button):
	timer += 10
	emit_signal("option_clicked", button.text)
