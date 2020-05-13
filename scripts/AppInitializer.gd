extends Node

func _ready():
	randomize()
	
	$DataController.initialize_data()
	$MainMenu.setup()
	$DraftScene.setup($DataController.draft_modes["normal_draft"], $DataController)
	$MainMenu.connect("draft_selected", self, "_on_draft_selected")
	$DraftScene.connect("draft_finished", self, "_on_draft_finished")

func _on_draft_selected():
	_reset()
	$DraftScene.present()

func _reset():
	$MainMenu.hide()
	$DraftScene.hide()

func _on_draft_finished():
	print("draft finished")
