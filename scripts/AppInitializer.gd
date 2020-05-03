extends Node

func _ready():
	randomize()
	
	$DataController.initialize_data()
	print($DataController.draft_modes)
	
	$DraftScene.setup($DataController.draft_modes["normal_draft"], $DataController)
	$DraftScene.connect("draft_finished", self, "_on_draft_finished")

func _on_draft_finished():
	print("draft finished")
