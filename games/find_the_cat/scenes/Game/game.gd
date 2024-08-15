extends Microgame


### Overrides
func _ready() -> void:
	var cat_types =  Utils.load_sprite_directory("res://games/find_the_cat/assets/sprites/cats/", true)
	# create the cats
	$Alley.cat_types = cat_types
	# create the highlight
	var highlight = Highlight.new()
	highlight.highlight_radius =$Alley.max_cat_size
	$Alley.highlight = highlight
	super.new_game()


func game_over(_meta: Dictionary = {}) -> void:
	won = true
	super.game_over()
### End Overrides
