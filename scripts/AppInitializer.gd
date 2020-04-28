extends Node

func _ready():
	$DataController.initialize_data()
	
	$DraftScene.connect("continue_pressed", self, "_on_continue_pressed")

func _on_continue_pressed():
	print("continue pressed")
