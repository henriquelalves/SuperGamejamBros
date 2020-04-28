extends Control

export(Array, NodePath) var button_pivots_nodepaths
export(Array, NodePath) var button_tier_nodepaths

onready var button_pivots : Array
onready var button_tiers : Array

onready var _data_controller : DataController

signal continue_pressed

func _ready():
	for pivot_nodepath in button_pivots_nodepaths:
		button_pivots.append(get_node(pivot_nodepath))
	
	for button_nodepath in button_tier_nodepaths:
		button_tiers.append(get_node(button_nodepath))
	
	for i in range(button_tiers.size()):
		var button_tier = button_tiers[i]
		button_tier.connect("left_bottom", self, "_on_button_tier_left_bottom", [button_tier])
		button_tier.connect("left_top", self, "_on_button_tier_left_top", [button_tier])
	$Continue.connect("pressed", self, "_on_continue_pressed")

func _on_button_tier_left_bottom(button_tier):
	var pivot_index = button_pivots.find(button_tier.pivot_control)
	
	if (pivot_index < 2):
		var changed_button = null
		for button in button_tiers:
			if (button.pivot_control == button_pivots[pivot_index+1]):
				changed_button = button
				break
		
		button_tier.pivot_control = button_pivots[pivot_index+1]
		changed_button.pivot_control = button_pivots[pivot_index]

func _on_button_tier_left_top(button_tier):
	var pivot_index = button_pivots.find(button_tier.pivot_control)
	
	if (pivot_index > 0):
		var changed_button = null
		for button in button_tiers:
			if (button.pivot_control == button_pivots[pivot_index-1]):
				changed_button = button
				break
		
		button_tier.pivot_control = button_pivots[pivot_index-1]
		changed_button.pivot_control = button_pivots[pivot_index]

func _on_continue_pressed():
	emit_signal("continue_pressed")
