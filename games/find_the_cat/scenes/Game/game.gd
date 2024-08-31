extends MicroGame

var _hunted_cat: Cat
var _cat_found = false

@onready var static_alley = $RGBAlley
@onready var alley = $BackBufferCopy/MonochromeAlley
@onready var flashlight = $BackBufferCopy/Flashlight

### Overrides
func _ready() -> void:
	var cat_types =  Utils.load_sprite_directory("res://games/find_the_cat/assets/sprites/cats/", true)
	# Set alley darkness
	alley.darkness = difficulty.get("darkness", 10.0)
	# Provide the flashlight's Rect2() that needs to be avoided when placing cats
	flashlight.global_position = get_viewport().size / 2
	# NOTE: I'm creating a Rect2 instance here as get_rect() position seems to be stuck at (-69, -69)
	alley.avoid = Rect2(flashlight.global_position, flashlight.get_rect().size)
	# create the cats
	alley.cat_types = cat_types
	_hunted_cat = alley.cats.pick_random()
	# recreate the cats in RGB in the static layer
	static_alley.cats = alley.cats
	super.new_game()


func game_over(_meta: Dictionary = {}) -> void:
	super.game_over()
### End Overrides


func _on_cat_found() -> void:
	print_debug("Cat has been found!")
	# Snap flashlight to center
	flashlight.enabled = false
	flashlight.global_position = _hunted_cat.global_position
	won = true
	_cat_found = true
	game_over()


func _process(_delta: float) -> void:
	if _cat_found:
		return

	# Check the distance between the hunted_cat and the highlight
	# the minimum distance is based on 25% flashlight's with
	if Utils.is_within_range(_hunted_cat, flashlight, flashlight.texture.get_width() * 0.25):
		_on_cat_found()
