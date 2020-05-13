extends Control

enum MainMenuState {
	START_MENU,DRAFT_MENU
}

signal draft_selected

var _state_stack : Array
var _start_menu_container : Control
var _draft_menu_container : Control

var _ranked_draft_button : Control
var _draft_button : Control
var _back_button : Control

func setup():
	_state_stack = []
	
	_start_menu_container = $NodePathTracker.get_node_by_name("StartMenuContainer")
	_draft_menu_container = $NodePathTracker.get_node_by_name("DraftMenuContainer")
	_draft_button = $NodePathTracker.get_node_by_name("DraftButton")
	_back_button = $NodePathTracker.get_node_by_name("BackButton")
	_ranked_draft_button = $NodePathTracker.get_node_by_name("RankedDraftButton")
	
	_draft_button.connect("pressed", self, "_next_state", [MainMenuState.DRAFT_MENU])
	_back_button.connect("pressed", self, "_back_state")
	_ranked_draft_button.connect("pressed", self, "emit_signal", ["draft_selected"])
	
	_next_state(MainMenuState.START_MENU)

func _reset():
	_start_menu_container.hide()
	_draft_menu_container.hide()
	_back_button.hide()

func _next_state(state : int):
	_state_stack.append(state)
	_set_state(_state_stack[-1])

func _back_state():
	_state_stack.pop_back()
	_set_state(_state_stack[-1])

func _set_state(menu_state : int):
	_reset()
	match(menu_state):
		MainMenuState.START_MENU:
			_start_menu_container.show()
		MainMenuState.DRAFT_MENU:
			_draft_menu_container.show()
			_back_button.show()
