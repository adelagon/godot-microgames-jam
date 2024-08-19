extends Microgame


### Overrides
func _ready() -> void:
	var cat_types =  Utils.load_sprite_directory("res://games/find_the_cat/assets/sprites/cats/", true)
	# create the cats
	$Alley.cat_types = cat_types
	$Alley.hunted_cat = $Alley.cats.pick_random()
	$Alley.connect("cat_found", _on_cat_found)
	super.new_game()


func game_over(_meta: Dictionary = {}) -> void:
	super.game_over()
### End Overrides

func _on_cat_found() -> void:
	print_debug("Cat has been found!")
	won = true
	game_over()
