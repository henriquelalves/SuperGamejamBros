extends Control

class_name DraftSceneChoiceView

signal option_clicked(option_label)

var buttons : Array

func setup():
	for button in $ChoicesGridContainer.get_children():
		buttons.append(button)
		button.connect("pressed", self, "_on_button_pressed", [button])

func set_labels(labels : Array):
	for i in range(buttons.size()):
		if (i < labels.size()):
			buttons[i].show()
			buttons[i].text = labels[i]
		else:
			buttons[i].hide()

func _on_button_pressed(button : Button):
	emit_signal("option_clicked", button.text)
