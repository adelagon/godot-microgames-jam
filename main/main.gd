extends Node

var config = ConfigFile.new()
var micro_games = []
var current_micro_game
var player_lives = 5


class MicrogameInfo:
	var game_name: String
	var scene: PackedScene
	var config: ConfigFile
	var path: String


func _ready() -> void:
	# Collate all available micro games
	config.load("res://main/config.ini")
	for key in config.get_section_keys("microgame_paths"):
		var path = config.get_value("microgame_paths", key)
		var micro_game_info = MicrogameInfo.new()
		micro_game_info.game_name = key
		micro_game_info.path = path
		micro_game_info.scene = load(path + "/scenes/Game/game.tscn")
		var micro_game_config = ConfigFile.new()
		print(path + "config.ini")
		var err = micro_game_config.load(path + "config.ini")
		if err != OK:
			printerr("Failed to parse micro game config: {game_name} with error: {err}"
				.format({"game_name": key, "err": err}))
			continue
		micro_game_info.config = micro_game_config
		micro_games.append(micro_game_info)
	$HUD.set_message("The Microgames will start in a few seconds")
	$HUD.set_lives(player_lives)
	$StartGameTimer.start()


# Starts a new random micro game
func _on_start_game_timer_timeout() -> void:
	$StartGameTimer.stop()
	var micro_game = micro_games.pick_random()
	current_micro_game = micro_game.scene.instantiate()
	current_micro_game.setup(micro_game.config, "easy")
	current_micro_game.connect("game_finished", self._on_micro_game_finished)
	$HUD.set_message(current_micro_game.directions)
	add_child(current_micro_game)
	if current_micro_game.timed and current_micro_game.timeout:
		$MicroGameTimer.start(current_micro_game.timeout)
		#$MicroGameTimer.start()
	

func player_won() -> void:
	$HUD.set_message("SUCCESS! Get ready for the next game!")


func player_lost() -> void:
	player_lives -= 1
	$HUD.set_message("FAILED! Get ready for the next game!")
	$HUD.set_lives(player_lives)
	
	if player_lives == 0:
		game_over()


# Triggered when microgame finishes
func _on_micro_game_finished(meta: Dictionary = {}) -> void:
	print("Game finished: ", meta)
	if current_micro_game.won:
		player_won()
	else:
		player_lost()
	$MicroGameTimer.stop()
	$MicroGameTransitionTimer.start()


# Triggered when player failed to finish a timed game
func _on_micro_game_timer_timeout() -> void:
	current_micro_game.end_game = true
	player_lost()
	$MicroGameTimer.stop()
	$MicroGameTransitionTimer.start()


func _on_micro_game_transition_timer_timeout() -> void:
	current_micro_game.queue_free()
	$MicroGameTransitionTimer.stop()
	$StartGameTimer.start()


func game_over() -> void:
	$HUD.set_message("GAME OVER!")
	$MicroGameTransitionTimer.stop()
	$MicroGameTimer.stop()
	$StartGameTimer.stop()
