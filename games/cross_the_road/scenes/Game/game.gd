extends Node

signal game_finished

const directions = "Cross the road!"
const timed = false

var player_won = false
var game_ended = false


func new_game():
	$Highway.connect("player_crossed", _on_player_crossed)
	$Player.position = $StartPosition.position
	$Player.connect("player_hit", _on_player_hit)


func game_over():
	if not player_won:
		if not game_ended:
			$LostSFX.play()
	else:
		player_won = true
		$WonSFX.play()
	if not game_ended:
		game_finished.emit(self.get_instance_id())
		game_ended = true


func _ready():
	new_game()


func _on_player_crossed():
	player_won = true
	game_over()


func _on_player_hit():
	game_over()

