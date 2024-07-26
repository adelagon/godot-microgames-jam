extends Node

@export var shoot_the_aliens: PackedScene
@export var cross_the_road: PackedScene

var micro_games = []
var current_micro_game
var player_lives = 5

func _ready():
	# Collate all available micro games
	micro_games.append(shoot_the_aliens)
	micro_games.append(cross_the_road)
	$HUD.set_message("The Microgames will start in a few seconds")
	$HUD.set_lives(player_lives)
	$StartGameTimer.start()


func _process(delta):
	pass


# Starts a new random micro game
func _on_start_game_timer_timeout():
	$StartGameTimer.stop()
	var micro_game = micro_games.pick_random()
	current_micro_game = micro_game.instantiate()
	current_micro_game.connect("game_finished", self._on_micro_game_finished)
	$HUD.set_message(current_micro_game.directions)
	add_child(current_micro_game)
	if current_micro_game.timed:
		$MicroGameTimer.start()
	

func player_won():
	$HUD.set_message("SUCCESS! Get ready for the next game!")


func player_lost():
	player_lives -= 1
	$HUD.set_message("FAILED! Get ready for the next game!")
	$HUD.set_lives(player_lives)
	
	if player_lives == 0:
		game_over()


# Triggered when microgame finishes
func _on_micro_game_finished(instance_id: int):
	if current_micro_game.player_won:
		player_won()
	else:
		player_lost()
	$MicroGameTimer.stop()
	$MicroGameTransitionTimer.start()


# Triggered when player failed to finish a timed game
func _on_micro_game_timer_timeout():
	current_micro_game.end_game = true
	player_lost()
	$MicroGameTimer.stop()
	$MicroGameTransitionTimer.start()


func _on_micro_game_transition_timer_timeout():
	current_micro_game.queue_free()
	$MicroGameTransitionTimer.stop()
	$StartGameTimer.start()


func game_over():
	$HUD.set_message("GAME OVER!")
	$MicroGameTransitionTimer.stop()
	$MicroGameTimer.stop()
	$StartGameTimer.stop()




