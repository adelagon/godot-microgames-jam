extends Node

var _menu: MainMenu
var _transition_page: TransitionPage
var _player_lives: int
var _count_down: int
var _last_message: String
var _micro_games = []
var _current_micro_games = []
var config = ConfigFile.new()

var current_micro_game
var player_lives = 5


class MicrogameInfo:
	var game_name: String
	var scene: PackedScene
	var config: ConfigFile
	var path: String

@export var menu_scene: PackedScene
@export var transition_page_scene: PackedScene


func _ready() -> void:
	# Collate all available micro games
	config.load("res://main/config.ini")
	_player_lives = config.get_value("main", "player_lives", 5)
	for key in config.get_section_keys("microgame_paths"):
		var path = config.get_value("microgame_paths", key)
		var micro_game_info = MicrogameInfo.new()
		micro_game_info.game_name = key
		micro_game_info.path = path
		micro_game_info.scene = load(path + "/scenes/Game/game.tscn")
		var micro_game_config = ConfigFile.new()
		var err = micro_game_config.load(path + "config.ini")
		if err != OK:
			printerr("Failed to parse micro game config: {game_name} with error: {err}"
				.format({"game_name": key, "err": err}))
			continue
		micro_game_info.config = micro_game_config
		_micro_games.append(micro_game_info)
	setup_menu()


# Starts a new random micro game
#func _on_start_game_timer_timeout() -> void:
	#$StartGameTimer.stop()
#	var micro_game = _micro_games.pick_random()
#	current_micro_game = micro_game.scene.instantiate()
#	current_micro_game.setup(micro_game.config, "easy")
#	current_micro_game.connect("game_finished", self._on_micro_game_finished)
	#$HUD.set_message(current_micro_game.directions)
#	add_child(current_micro_game)
#	if current_micro_game.timed and current_micro_game.timeout:
#		$MicroGameTimer.start(current_micro_game.timeout)


func _on_menu_button_pressed(button_name: String, meta: Dictionary = {}):
	print_debug("Menu Action: {0} -> {1}".format([button_name, meta]))
	match button_name:
		"new_game":
			_menu.hide()
			setup_game(meta)
		"quit":
			get_tree().quit()
		"_":
			pass


func setup_menu() -> void:
	# Prepare the menu
	_menu = menu_scene.instantiate()
	_menu.connect("on_menu_button_pressed", _on_menu_button_pressed)
	add_child(_menu)


func setup_game(meta: Dictionary):
	# Prepare the micro games
	_micro_games.shuffle()
	for micro_game in _micro_games:
		var micro_game_instance = micro_game.scene.instantiate()
		micro_game_instance.setup(micro_game.config, meta.get("difficulty"))
		micro_game_instance.connect("game_finished", self._on_micro_game_finished)
		_current_micro_games.append(micro_game_instance)

	# Prepare the transition page
	_transition_page = transition_page_scene.instantiate()
	_count_down = 3
	_last_message = "Get Ready in {0}!!!"
	_transition_page.message = _last_message.format([_count_down])
	_transition_page.lives = _player_lives
	$TickTimer.start()
	add_child(_transition_page)


func setup_micro_game(micro_game: MicroGame) -> void:
	add_child(micro_game)
#	var micro_game = _micro_games.pick_random()
#	current_micro_game = micro_game.scene.instantiate()
#	current_micro_game.setup(micro_game.config, "easy")
#	current_micro_game.connect("game_finished", self._on_micro_game_finished)
	#$HUD.set_message(current_micro_game.directions)
#	add_child(current_micro_game)
#	if current_micro_game.timed and current_micro_game.timeout:
#		$MicroGameTimer.start(current_micro_game.timeout)


func player_won() -> void:
	_count_down = 2
	_transition_page.message = "You got it!"
	_transition_page.lives = _player_lives
	_transition_page.show()
	$TickTimer.start()
	


func player_lost() -> void:
	_player_lives -= 1
	_count_down = 2
	_transition_page.message = "You failed!"
	_transition_page.lives = _player_lives
	_transition_page.show()
	$TickTimer.start()
	#$HUD.set_message("FAILED! Get ready for the next game!")
	#$HUD.set_lives(player_lives)
	
	if player_lives == 0:
		game_over()


# Triggered when microgame finishes
func _on_micro_game_finished(micro_game: MicroGame, meta: Dictionary = {}) -> void:
	print("Game finished: ", micro_game, meta)
	if micro_game.won:
		player_won()
	else:
		player_lost()
	micro_game.queue_free()
	#$MicroGameTimer.stop()
	#$MicroGameTransitionTimer.start()


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


func _on_tick_timer_timeout() -> void:
	_count_down -= 1
	_transition_page.message = _last_message.format([_count_down])
	if _count_down == 0:
		$TickTimer.stop()
		_transition_page.hide()
		setup_micro_game(_current_micro_games.pop_front())
