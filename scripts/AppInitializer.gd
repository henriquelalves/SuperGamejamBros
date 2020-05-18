extends Node

enum CurrentScene {
	MainMenu,
	EnterScreen,
	Draft
}

export(PackedScene) var main_menu_scene
export(PackedScene) var enter_screen_scene
export(PackedScene) var draft_scene

func _ready():
	randomize()
	
	$DataController.initialize_data()
	
	_show_scene(CurrentScene.EnterScreen)

func _clean_scene():
	if ($CurrentScene.get_child_count() > 0):
		$CurrentScene.get_child(0).queue_free()

func _on_start_pressed():
	_show_scene(CurrentScene.MainMenu)
	
func _on_draft_selected():
	_show_scene(CurrentScene.Draft)

func _on_draft_finished():
	_show_scene(CurrentScene.MainMenu)

func _show_scene(current_scene : int):
	_clean_scene()
	var scene_node : Node
	
	match(current_scene):
		CurrentScene.MainMenu:
			scene_node = main_menu_scene.instance()
			$CurrentScene.add_child(scene_node)
			scene_node.setup()
			scene_node.connect("draft_selected", self, "_on_draft_selected")
		
		CurrentScene.Draft:
			scene_node = draft_scene.instance()
			$CurrentScene.add_child(scene_node)
			scene_node.setup($DataController.draft_modes["normal_draft"], $DataController)
			scene_node.connect("draft_finished", self, "_on_draft_finished")
			scene_node.present()
		
		CurrentScene.EnterScreen:
			scene_node = enter_screen_scene.instance()
			$CurrentScene.add_child(scene_node)
			scene_node.connect("start_pressed", self, "_on_start_pressed")

func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.scancode == KEY_F11:
			OS.window_fullscreen = not OS.window_fullscreen
