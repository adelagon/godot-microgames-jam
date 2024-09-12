extends Control
class_name Directions

### Game Title
var _game_title = "Game Title"
var game_title: String:
	get:
		return _game_title
	set(value):
		_game_title = value
		%GameTitle.text = value

var _game_directions = "Game Directions"
var game_directions: String:
	get:
		return _game_directions
	set(value):
		_game_directions = value
		%GameDirections.text = value
		
var _game_metadata = []
var game_metadata: Array:
	get:
		return _game_metadata
	set(value):
		_game_metadata = value
		for metadata in _game_metadata:
			%GameMetaData.add_child(metadata)


var _game_controls = []
var game_controls: Array:
	get:
		return _game_controls
	set(value):
		_game_controls = value
		for control in _game_controls:
			%GameControls.add_child(control)

#func set_controls(controls: Array) -> void:
	# Cle
#	for child in %GameControls.get_children():
#		%GameControls.remove_child(child)
		
#	for control in controls:
#		%GameControls.add_child(control)
