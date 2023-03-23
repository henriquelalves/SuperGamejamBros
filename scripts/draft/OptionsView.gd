extends Control

class_name DraftSceneOptionsView

var draft_option_container_scene = preload("res://scenes/draft/DraftOptionContainer.tscn")
var draft_option_button_scene = preload("res://scenes/draft/DraftOptionButton.tscn")

var button_pivots : Array
var button_tiers : Array
var button_tiers_container : Control
var draft_data : Array

signal continue_pressed


func setup(draft_mode : DraftMode):
	$ContinueButton.connect("pressed", self, "_on_continue_pressed")
	
	var option_labels = ["Consoles", "Games", "Tools"]
	
	draft_data = [draft_mode.choiceA, draft_mode.choiceB, draft_mode.choiceC]
	
	for i in range(3-draft_mode.steps):
		draft_data.pop_back()
		option_labels.pop_back()
	
	for option_label in option_labels:
		var draft_option = draft_option_container_scene.instance()
		draft_option.setup(option_label)
		button_pivots.append(draft_option.pivot)
		$DraftOptionsContainer.add_child(draft_option)
	
	for i in range(draft_data.size()):
		var draft_label = str(draft_data[i]) + " Options"
		var button = draft_option_button_scene.instance()
		button.setup(button_pivots[i], draft_label)
		button_tiers.append(button)
		button.connect("left_bottom", self, "_on_button_tier_left_bottom", [button])
		button.connect("left_top", self, "_on_button_tier_left_top", [button])
		button.choices_data = draft_data[i]
		$ButtonTiersContainer.add_child(button)


func present():
	yield(get_tree(),"idle_frame")
	
	for button in button_tiers:
		button.reset_position()
		print(button)


func _on_button_tier_left_bottom(button_tier):
	var pivot_index = button_pivots.find(button_tier.pivot_control)
	
	if (pivot_index < 2):
		var changed_button = null
		for button in button_tiers:
			if (button.pivot_control == button_pivots[pivot_index+1]):
				changed_button = button
				break
		
		button_tier.pivot_control.get_child(0).hide()
		button_tier.pivot_control = button_pivots[pivot_index+1]
		button_tier.pivot_control.get_child(0).show()
		changed_button.pivot_control = button_pivots[pivot_index]


func _on_button_tier_left_top(button_tier):
	var pivot_index = button_pivots.find(button_tier.pivot_control)
	
	if (pivot_index > 0):
		var changed_button = null
		for button in button_tiers:
			if (button.pivot_control == button_pivots[pivot_index-1]):
				changed_button = button
				break
		
		button_tier.pivot_control.get_child(0).hide()
		button_tier.pivot_control = button_pivots[pivot_index-1]
		button_tier.pivot_control.get_child(0).show()
		changed_button.pivot_control = button_pivots[pivot_index]


func _on_continue_pressed():
	for button in button_tiers:
		var pivot_index = button_pivots.find(button.pivot_control)
		draft_data[pivot_index] = button.choices_data
	emit_signal("continue_pressed", draft_data)
