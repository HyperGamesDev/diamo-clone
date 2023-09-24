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
