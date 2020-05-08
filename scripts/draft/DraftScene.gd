extends Control

enum DRAFT_STATE {SETTING_UP, CONSOLE_CHOICE, GAME_CHOICE, TOOL_CHOICE, RESULTS}

var current_state = 0

var draft_option_container_scene = preload("res://scenes/draft/DraftOptionContainer.tscn")
var draft_option_button_scene = preload("res://scenes/draft/DraftOptionButton.tscn")

var button_pivots : Array
var button_tiers : Array
var draft_data : Array
var chosen_console : String
var chosen_game : String
var chosen_tool : String

var _data_controller : DataController

var draft_options_view : Control
var choice_view : DraftSceneChoiceView
var results_view : DraftSceneResultsView
var draft_options_container : Container
var button_tiers_container : Control
var continue_button : Button

var picked_console : String
var picked_game : String
var picked_tool : String

signal draft_finished

func setup(draft_mode : DraftMode, data_controller : DataController):
	_data_controller = data_controller
	
	current_state = DRAFT_STATE.SETTING_UP
	
	draft_options_container = $NodePathTracker.get_node_by_name("DraftOptionsContainer")
	button_tiers_container = $NodePathTracker.get_node_by_name("ButtonTiersContainer")
	continue_button = $NodePathTracker.get_node_by_name("ContinueButton")
	choice_view = $NodePathTracker.get_node_by_name("ChoiceView")
	draft_options_view = $NodePathTracker.get_node_by_name("DraftOptionsView")
	results_view = $NodePathTracker.get_node_by_name("ResultsView")
	
	choice_view.setup()
	choice_view.connect("option_clicked", self, "_on_choice_option_clicked")
	
	var option_labels = ["Consoles", "Games", "Tools"]
	
	draft_data = [draft_mode.choiceA, draft_mode.choiceB, draft_mode.choiceC]
	
	for option_label in option_labels:
		var draft_option = draft_option_container_scene.instance()
		draft_option.setup(option_label)
		button_pivots.append(draft_option.pivot)
		draft_options_container.add_child(draft_option)
	
	yield(get_tree(), "idle_frame")
	
	for i in range(draft_data.size()):
		var draft_label = str(draft_data[i]) + " Options"
		var button = draft_option_button_scene.instance()
		button.setup(button_pivots[i], draft_label)
		button_tiers.append(button)
		button.connect("left_bottom", self, "_on_button_tier_left_bottom", [button])
		button.connect("left_top", self, "_on_button_tier_left_top", [button])
		button.choices_data = draft_data[i]
		button_tiers_container.add_child(button)
		
	continue_button.connect("pressed", self, "_on_continue_pressed")

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

func _on_choice_option_clicked(option_label : String):
	match current_state:
		DRAFT_STATE.CONSOLE_CHOICE:
			chosen_console = option_label
		DRAFT_STATE.GAME_CHOICE:
			chosen_game = option_label
		DRAFT_STATE.TOOL_CHOICE:
			chosen_tool = option_label
	_next_state()

func _on_continue_pressed():
	match current_state:
		DRAFT_STATE.SETTING_UP:
			for button in button_tiers:
				var pivot_index = button_pivots.find(button.pivot_control)
				draft_data[pivot_index] = button.choices_data
			_next_state()
		DRAFT_STATE.RESULTS:
			emit_signal("draft_finished")

func _next_state():
	match current_state:
		DRAFT_STATE.SETTING_UP:
			draft_options_view.hide()
			choice_view.show()
			continue_button.hide()
			choice_view.set_labels(_data_controller.get_random_consoles(draft_data[0]))
			current_state = DRAFT_STATE.CONSOLE_CHOICE
		DRAFT_STATE.CONSOLE_CHOICE:
			choice_view.set_labels(_data_controller.get_random_games(chosen_console, draft_data[1]))
			current_state = DRAFT_STATE.GAME_CHOICE
		DRAFT_STATE.GAME_CHOICE:
			choice_view.set_labels(_data_controller.get_random_tools(draft_data[2]))
			current_state = DRAFT_STATE.TOOL_CHOICE
		DRAFT_STATE.TOOL_CHOICE:
			pass
			results_view.setup(["Console", "Game", "Tool"], [chosen_console, chosen_game, chosen_tool])
			results_view.show()
			choice_view.hide()
			continue_button.show()
			current_state = DRAFT_STATE.RESULTS
