extends Node

@export var shoot_the_aliens: PackedScene

var micro_games = []
var current_micro_game
var player_lives = 5

func _ready():
	# Collate all available micro games
	micro_games.append(shoot_the_aliens)
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
	$MicroGameTimer.start()
	

# Triggers when player successfully finishes the game before microgame timer
func _on_micro_game_finished(instance_id: int):
	print("microgame finished")
	current_micro_game.queue_free()
	$HUD.set_message("SUCCESS! Get ready for the next game!")
	$StartGameTimer.start()
	$MicroGameTimer.stop()

# Trigger when player failed to finish the game before microgame timer
func _on_micro_game_timer_timeout():
	$MicroGameTimer.stop()
	current_micro_game.queue_free()
	
	if player_lives == 0:
		game_over()
		return

	player_lives -= 1
	$HUD.set_message("FAILED! Get ready for the next game!")
	$HUD.set_lives(player_lives)
	$StartGameTimer.start()


func game_over():
	$HUD.set_message("GAME OVER!")
