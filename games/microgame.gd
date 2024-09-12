extends Node
class_name MicroGame

var config: ConfigFile
var start_time: float
var end_time: float
var _directions: Directions   # Short description of the micro game
var timed: bool               # flag wether the game is timed or not
var timeout: int              # determines how long the micro game lasts
var difficulty: Dictionary    # difficulty settings
var metadata: Array           # Any game metadata that will be shown in the directions scene


### Setting this property to true should forcefully end the game (ie. Timer ran out)
var _end_game = false
var end_game: bool: 
	get:
		return _end_game
	set(value):
		if value:
			game_over({'noemit': true})
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
	#directions = config.get_value("game", "direction")
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
	show_directions()
	# Give player two seconds to understand the directions
	await get_tree().create_timer(2).timeout
	hide_directions()
	start_time = Time.get_unix_time_from_system()
	print_debug("Game started at: ", start_time)

func show_directions() -> void:
	# Show Game Details
	_directions = preload("res://games/directions.tscn").instantiate()
	_directions.game_title = config.get_value("game", "name")
	_directions.game_directions = config.get_value("game", "direction")
	# Show Controls
	var controls = []
	for control in config.get_value("game", "joypad_controls"):
		# TODO: show default xbox controls for now, we should autodetect the 
		#       control type here first
		var control_type = "xbox"
		var control_res = "res://games/assets/controls/{0}/{0}_{1}.png".format([control_type, control])
		var control_texture = Utils.load_texture_rect_from_image(control_res)
		controls.append(control_texture)
	_directions.game_controls = controls
	# Show Metadata
	var meta = []
	for m in metadata:
		if m is ImageTexture:
			var texture_rect = TextureRect.new()
			texture_rect.texture = m
			meta.append(texture_rect)
	_directions.game_metadata = meta
	add_child(_directions)
	_directions.show()
	

func hide_directions() -> void:
	_directions.hide()


func game_over(meta: Dictionary = {}) -> void:
	# game_over() should be triggered manually by each microgame once the 
	# game is finished regardless of the player success outcome
	end_time = Time.get_unix_time_from_system()
	var time_elapsed = end_time - start_time
	print_debug("Game ended at: ", Time.get_unix_time_from_system())
	print_debug("Time elapsed: ", end_time - start_time)
	if meta.get("noemit") == true:
		return
	meta['time_elapsed'] = time_elapsed
	meta['won'] = won
	meta['instance_id'] = self.get_instance_id()
	game_finished.emit(self, meta)
### End Micrograme commons
