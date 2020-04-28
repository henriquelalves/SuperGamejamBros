extends Node

class_name DataController

const RAW_LISTS_GAMES_PATH = "res://data/raw_lists/games/"
const RAW_LISTS_TOOLS_PATH = "res://data/raw_lists/tools/"

var games_dictionary : Dictionary
var tools_dictionary : Dictionary

func initialize_data():
	var games_files = []
	var tools_files = []
	
	var dir = Directory.new()
	
	dir.open(RAW_LISTS_GAMES_PATH)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and not file.ends_with('.import'):
			games_files.append(file)
	dir.list_dir_end()

	dir.open(RAW_LISTS_TOOLS_PATH)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and not file.ends_with('.import'):
			tools_files.append(file)
	dir.list_dir_end()

	var file = File.new()
	for console_file in games_files:
		games_dictionary[console_file] = []
		
		file.open(RAW_LISTS_GAMES_PATH + console_file, File.READ)
		var game = file.get_line()
		while (game != null and not game.empty()):
			games_dictionary[console_file].append(game)
			game = file.get_line()
	
	for tools_file in tools_files:
		file.open(RAW_LISTS_TOOLS_PATH + tools_file, File.READ)
		var tool_tag = file.get_csv_line()
		tools_dictionary[tool_tag] = []
		
		var tool_name = file.get_csv_line()
		while (tool_name != null and not tool_name[0].empty()):
			tools_dictionary[tool_tag].append(tool_name[0])
			tool_name = file.get_csv_line()
