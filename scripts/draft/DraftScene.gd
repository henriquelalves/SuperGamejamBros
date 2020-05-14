extends Control

enum DRAFT_STATE {SETTING_UP, CONSOLE_CHOICE, GAME_CHOICE, TOOL_CHOICE, RESULTS}

var current_state = 0

var draft_option_container_scene = preload("res://scenes/draft/DraftOptionContainer.tscn")
var draft_option_button_scene = preload("res://scenes/draft/DraftOptionButton.tscn")

var draft_data : Array
var chosen_console : String
var chosen_game : String
var chosen_tool : String

var _data_controller : DataController
var tween : Tween
var worm_hole_animation : AnimationPlayer
var worm_hole_effect : ColorRect

var options_view : DraftSceneOptionsView
var choice_view : DraftSceneChoiceView
var results_view : DraftSceneResultsView

var picked_console : String
var picked_game : String
var picked_tool : String

signal draft_finished

func setup(draft_mode : DraftMode, data_controller : DataController):
	_data_controller = data_controller
	
	current_state = DRAFT_STATE.SETTING_UP
	
	tween = $Tween
	
	worm_hole_effect = $NodePathTracker.get_node_by_name("WormHoleEffect")
	worm_hole_animation = worm_hole_effect.get_child(0)
	worm_hole_effect.setup()
	
	options_view = $NodePathTracker.get_node_by_name("OptionsView")
	choice_view = $NodePathTracker.get_node_by_name("ChoiceView")
	results_view = $NodePathTracker.get_node_by_name("ResultsView")
	
	options_view.setup(draft_mode)
	options_view.connect("continue_pressed", self, "_options_continue_pressed")
	
	choice_view.setup()
	choice_view.connect("option_clicked", self, "_on_choice_option_clicked")

func present():
	show()
	tween.interpolate_property($Background, ":modulate:a", 0, 1, 0.2,Tween.TRANS_CUBIC,Tween.EASE_OUT)
	tween.start()
	options_view.present()

func _options_continue_pressed(data):
	draft_data = data
	_next_state()

func _on_choice_option_clicked(option_label : String):
	match current_state:
		DRAFT_STATE.CONSOLE_CHOICE:
			chosen_console = option_label
		DRAFT_STATE.GAME_CHOICE:
			chosen_game = option_label
		DRAFT_STATE.TOOL_CHOICE:
			chosen_tool = option_label
	_next_state()

func _next_state():
	match current_state:
		DRAFT_STATE.SETTING_UP:
			options_view.hide()
			choice_view.present()
			choice_view.set_labels(_data_controller.get_random_consoles(draft_data[0]))
			worm_hole_animation.play("level_1")
			choice_view.set_title("Choose your console!")
			current_state = DRAFT_STATE.CONSOLE_CHOICE
		DRAFT_STATE.CONSOLE_CHOICE:
			choice_view.set_labels(_data_controller.get_random_games(chosen_console, draft_data[1]))
			worm_hole_animation.play("level_2")
			choice_view.set_title("Choose your game!")
			current_state = DRAFT_STATE.GAME_CHOICE
		DRAFT_STATE.GAME_CHOICE:
			choice_view.set_labels(_data_controller.get_random_tools(draft_data[2]))
			worm_hole_animation.play("level_3")
			choice_view.set_title("Choose your weapon!")
			current_state = DRAFT_STATE.TOOL_CHOICE
		DRAFT_STATE.TOOL_CHOICE:
			pass
			results_view.setup(["Console", "Game", "Tool"], [chosen_console, chosen_game, chosen_tool])
			results_view.show()
			choice_view.dismiss()
			current_state = DRAFT_STATE.RESULTS
