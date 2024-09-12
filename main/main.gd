extends Node

var _menu: MainMenu
var _transition_page: TransitionPage
var _player_lives: int
var _count_down: int
var _last_message: String
var _current_micro_game: MicroGame
var _micro_games = []
var _micro_games_session = []
var config = ConfigFile.new()


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
	_player_lives = config.get_value("main", "player_lives", 3)
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


func _on_menu_button_pressed(button_name: String, meta: Dictionary = {}):
	print_debug("Menu Action: {0} -> {1}".format([button_name, meta]))
	match button_name:
		"new_game":
			_menu.hide()
			$BackgroundMusic.stop()
			setup_session(meta)
		"quit":
			get_tree().quit()
		"_":
			pass


func setup_menu() -> void:
	# Prepare the menu
	_menu = menu_scene.instantiate()
	_menu.connect("on_menu_button_pressed", _on_menu_button_pressed)
	add_child(_menu)


func setup_session(meta: Dictionary):
	# Prepare the micro games
	_micro_games.shuffle()
	var session_length = config.get_value("main", "session_length", 10)
	var game_session = []
	if len(_micro_games) <= session_length:
		game_session.append_array(_micro_games)
		# Fill gap with random games
		for i in session_length - len(_micro_games):
			game_session.append(_micro_games.pick_random())
	else:
		for i in session_length:
			game_session.append(_micro_games.pick_random())

	for micro_game in game_session:
		var micro_game_instance = micro_game.scene.instantiate()
		micro_game_instance.setup(micro_game.config, meta.get("difficulty"))
		micro_game_instance.connect("game_finished", self._on_micro_game_finished)
		_micro_games_session.append(micro_game_instance)

	# Prepare the transition page
	_transition_page = transition_page_scene.instantiate()
	_count_down = 3
	_last_message = "Get Ready in {0}!!!"
	_transition_page.message = _last_message.format([_count_down])
	_transition_page.lives = _player_lives
	add_child(_transition_page)
	$TickTimer.start()


func start_micro_game(micro_game: MicroGame) -> void:
	_current_micro_game = micro_game
	add_child(micro_game)
	# If microgame is timed, start a timer
	if micro_game.timed and micro_game.timeout:
		$MicroGameTimer.start(micro_game.timeout)


func show_player_won() -> void:
	_transition_page.message = "Great job!"
	_transition_page.show()


func show_player_lost() -> void:
	_transition_page.message = "You failed!"
	_transition_page.lives = _player_lives
	_transition_page.show()


func play_next() -> void:
	# Player ran out of lives
	if _player_lives == 0:
		game_over()
		return

	# All microgames in a session has been played
	if len(_micro_games_session) == 0:
		game_over(true)
		return

	start_micro_game(_micro_games_session.pop_front())


func game_over(success: bool = false) -> void:
	print_debug("Game session over with success: ", success)
	if success:
		# TODO: Show successful game over page here
		_transition_page.message = "Game Over, you have won!"
		
	else:
		# TODO: Show successful game over page here
		_transition_page.message = "Game Over, you failed!"
	_transition_page.lives = _player_lives
	_transition_page.show()


# Triggered when microgame finishes
func _on_micro_game_finished(micro_game: MicroGame, meta: Dictionary = {}) -> void:
	print_debug("Game finished: ", micro_game, meta)
	if micro_game.timed:
		$MicroGameTimer.stop()
	# Give microgame 2 secs to do post play activity
	await get_tree().create_timer(2).timeout
	micro_game.queue_free()
	if micro_game.won:
		show_player_won()
	else:
		_player_lives -= 1
		show_player_lost()
	await get_tree().create_timer(2).timeout
	_transition_page.hide()
	play_next()


# Triggered when player failed to finish a timed game
func _on_micro_game_timer_timeout() -> void:
	print_debug("Game finished with player ran out of time: ", _current_micro_game)
	_current_micro_game.end_game = true
	await get_tree().create_timer(2).timeout
	_current_micro_game.queue_free()
	_player_lives -= 1
	show_player_lost()
	$MicroGameTimer.stop()
	await get_tree().create_timer(2).timeout
	_transition_page.hide()
	play_next()

# Used specifically to show a count down on the UI
func _on_tick_timer_timeout() -> void:
	_count_down -= 1
	_transition_page.message = _last_message.format([_count_down])
	if _count_down == 0:
		$TickTimer.stop()
		_transition_page.hide()
		play_next()
