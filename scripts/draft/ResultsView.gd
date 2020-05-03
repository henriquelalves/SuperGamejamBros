extends Control

class_name DraftSceneResultsView

var draft_result_info_scene = preload("res://scenes/draft/DraftResultInfo.tscn")

func setup(info_titles : Array, info_labels : Array):
	for i in range(info_labels.size()):
		var info = draft_result_info_scene.instance()
		$ResultsInfoContainer.add_child(info)
		info.set_text(info_titles[i], info_labels[i])
