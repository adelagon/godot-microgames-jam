extends Microgame


### Overrides
func _ready() -> void:
	$Alley.cat_types = Utils.load_sprite_directory("res://games/find_the_cat/assets/sprites/cats/", true)
	super.new_game()



func game_over(_meta: Dictionary = {}) -> void:
	won = true
	super.game_over()
### End Overrides
