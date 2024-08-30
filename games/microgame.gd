extends Node
class_name Microgame

var config: ConfigFile
var start_time: float
var end_time: float
var directions: String       # Short description of the micro game
var timed: bool              # flag wether the game is timed or not
var timeout: int             # determines how long the micro game lasts
var difficulty: Dictionary   # difficulty settings

### Setting this property to true should forcefully end the game (ie. Timer ran out)
var _end_game = false
var end_game: bool: 
	get:
		return _end_game
	set(value):
		if value:
			game_over({"timeout": true})
### Set this property if player wins or not
var _won = false
var won: bool:
	get:
		return _won
	set(value):
		_won = value
		
signal game_finished

### Microgame commons
func setup(cfg: ConfigFile, difficulty_selection: String = "easy") -> void:
	config = cfg
	directions = config.get_value("game", "direction")
	timed = config.get_value("game", "timed")
	# Set difficulty
	var section_name = "difficulty." + difficulty_selection
	difficulty["selection"] = difficulty_selection
	for key in config.get_section_keys(section_name):
		difficulty[key] = config.get_value(section_name, key)
		if key == "timeout" and timed:
			timeout = config.get_value(section_name, key)


func new_game() -> void:
	# new_game() should be triggered manually by each microgame after all its
	# internal setup has been finished.
	start_time = Time.get_unix_time_from_system()
	print_debug("Game started at: ", start_time)
	# TODO: placeholder for implementing the game instruction UI


func game_over(meta: Dictionary = {}) -> void:
	# game_over() should be triggered manually by each microgame once the 
	# game is finished regardless of the player success outcome
	end_time = Time.get_unix_time_from_system()
	var time_elapsed = end_time - start_time
	print_debug("Game ended at: ", Time.get_unix_time_from_system())
	print_debug("Time elapsed: ", end_time - start_time)
	meta['time_elapsed'] = time_elapsed
	meta['won'] = won
	meta['instance_id'] = self.get_instance_id()
	game_finished.emit(meta)
### End Micrograme commons
