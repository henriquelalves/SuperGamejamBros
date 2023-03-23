extends Control

enum MainMenuState {
	START_MENU,DRAFT_MENU
}

signal draft_selected(draft_mode)

onready var _start_menu_container : Control = $"%StartMenuContainer"
onready var _draft_menu_container : Control = $"%DraftMenuContainer"
onready var _draft_button : Control = $"%DraftButton"
onready var _full_draft_button : Button = $"%FullDraftButton"
onready var _game_draft_button : Button = $"%GameDraftButton"
onready var _back_button : Button = $"%BackButton"

var _state_stack : Array


func setup():
	_state_stack = []
	
	_draft_button.connect("pressed", self, "_next_state", [MainMenuState.DRAFT_MENU])
	_back_button.connect("pressed", self, "_back_state")

	_full_draft_button.connect("pressed", self, "emit_signal", ["draft_selected", "full_draft"])
	_game_draft_button.connect("pressed", self, "emit_signal", ["draft_selected", "game_draft"])

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
