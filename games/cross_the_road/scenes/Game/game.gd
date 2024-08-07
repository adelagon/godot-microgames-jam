extends Microgame

var game_ended = false

### Overrides
func game_over(_meta: Dictionary = {}) -> void:
	if not won:
		if not game_ended:
			$LostSFX.play()
	else:
		won = true
		$WonSFX.play()
	if not game_ended:
		super.game_over()
		game_ended = true


func new_game() -> void:
	$Highway.vehicle_speed = difficulty.get("vehicle_speed")
	$Highway.max_vehicles_on_screen = difficulty.get("max_vehicles_on_screen")
	$Highway.connect("player_crossed", _on_player_crossed)
	$Player.position = $StartPosition.position
	$Player.connect("player_hit", _on_player_hit)
	super.new_game()
### End Overrides


### Game logic
func _ready() -> void:
	new_game()


func _on_player_crossed() -> void:
	won = true
	game_over()


func _on_player_hit() -> void:
	game_over()
