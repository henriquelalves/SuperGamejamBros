class_name DataController
extends Node

const RAW_LISTS_GAMES_PATH = "res://data/raw_lists/games/"
const RAW_LISTS_TOOLS_PATH = "res://data/raw_lists/tools/"
const DRAFT_MODES_PATH = "res://data/draft_modes/"

var games_dictionary : Dictionary
var tools_dictionary : Dictionary
var draft_modes : Dictionary


func get_random_games(console : String, number : int) -> Array:
	var console_games = games_dictionary[console] as Array
	console_games.shuffle()
	return console_games.slice(0, number-1)


func get_random_consoles(number : int) -> Array:
	var consoles = games_dictionary.keys() as Array
	consoles.shuffle()
	return consoles.slice(0, number-1)


func get_random_tools(number : int) -> Array:
	var tools = tools_dictionary["game-engines"] as Array
	tools.shuffle()
	return tools.slice(0, number-1)


func initialize_data():
	_load_games_data()
	_load_tools_data()
	_load_draft_modes()


func _load_draft_modes():
	var dir = Directory.new()
	
	dir.open(DRAFT_MODES_PATH)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and not file.ends_with('.import'):
			draft_modes[file.get_basename()] = load(DRAFT_MODES_PATH + file) as DraftMode
	dir.list_dir_end()


func _load_games_data():
	var games_files = []
	
	var dir = Directory.new()
	
	dir.open(RAW_LISTS_GAMES_PATH)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and not file.ends_with('.import'):
			games_files.append(file)
			print(games_files)
	dir.list_dir_end()

	var file = File.new()
	for console_file in games_files:
		games_dictionary[console_file] = []
		
		file.open(RAW_LISTS_GAMES_PATH + console_file, File.READ)
		var game = file.get_line()
		while (game != null and not game.empty()):
			games_dictionary[console_file].append(game)
			game = file.get_line()


func _load_tools_data():
	var tools_files = []
	
	var dir = Directory.new()

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
	for tools_file in tools_files:
		file.open(RAW_LISTS_TOOLS_PATH + tools_file, File.READ)
		var tool_tag = file.get_csv_line()
		tools_dictionary[tools_file.get_basename()] = []
		
		var tool_name = file.get_csv_line()
		while (tool_name != null and not tool_name[0].empty()):
			tools_dictionary[tools_file.get_basename()].append(tool_name[0])
			tool_name = file.get_csv_line()
