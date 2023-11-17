extends Node


const SAVE_PATH="res://savegame.json"

func _ready():
	self.set_process_mode(PROCESS_MODE_ALWAYS)
	
	load_game()

func save_game():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data={
		"highscore": Game.highscore,
	}
	var jstr=JSON.stringify(data)
	file.store_line(jstr)
	
func load_game():
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if FileAccess.file_exists(SAVE_PATH):
		if not file.eof_reached():
			var current_line=JSON.parse_string(file.get_line())
			if(current_line):
				Game.highscore=current_line["highscore"]


#func find_nodes_with_string(node, search_string):
#	var matching_nodes = []
#
#	if node.has_meta("name"):
#		var node_name = node.get_meta("name")
#		if search_string in node_name:
#			matching_nodes.append(node)
#
#	for child in node.get_children():
#		var child_matching_nodes = find_nodes_with_string(child, search_string)
#		matching_nodes.append_array(child_matching_nodes)  # Use append_array here
#
#	return matching_nodes

func find_nodes_with_string(node, search_string):
	var matching_nodes = []

	if search_string in node.name:
		matching_nodes.append(node)

	for child in node.get_children():
		var child_matching_nodes = find_nodes_with_string(child, search_string)
		matching_nodes += child_matching_nodes

	return matching_nodes
