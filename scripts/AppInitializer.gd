extends Node

func _ready():
	randomize()
	
	$DataController.initialize_data()
	$MainMenu.setup()
	$DraftScene.setup($DataController.draft_modes["normal_draft"], $DataController)
	$MainMenu.connect("draft_selected", self, "_on_draft_selected")
	$DraftScene.connect("draft_finished", self, "_on_draft_finished")
	$EnterScreen.connect("start_pressed", self, "_on_start_pressed")

func _on_start_pressed():
	$EnterScreen.hide()
	$MainMenu.show()

func _on_draft_selected():
	_reset()
	$DraftScene.present()

func _reset():
	$MainMenu.hide()
	$DraftScene.hide()

func _on_draft_finished():
	print("draft finished")

func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.scancode == KEY_F11:
			OS.window_fullscreen = not OS.window_fullscreen
