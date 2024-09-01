extends TextureRect

@export var cat_scene: PackedScene
# List of all Rect2 of cats that has been properly positioned
var _placed_cats = []


# Dictionary of Cat Types
var _cat_types = {}
var cat_types: Dictionary: 
	get:
		return _cat_types
	set(value):
		_cat_types = value
		initialize_alley()
# List of all cats in the alley
var _cats = []
var cats: Array:
	get:
		return _cats
# Set the darkness based on difficulty
var _darkness = 0.0
var darkness: float:
	get:
		return _darkness
	set(value):
		_darkness = value
		material.set_shader_parameter("darkness", value)

# Rect2 that needs to be avoided when placing cats
var _avoid
var avoid: Rect2:
	set(value):
		_avoid = value


func place_cat(cat: Cat, to_avoid: Rect2) -> void:
	# This function will do its best to randomly place cats that
	# shouldn't intersects each other and the highlight.
	#
	# On some cases, the intersects() function is not firing even
	# they visually intersect, TODO: find a way to fix this
	
	# Bound the cat to certain position basing on texture size.
	# This prevents the cats from being spawned outside the viewport
	var screen_size = get_viewport_rect().size
	var texture_size = cat.sprite.get_size() / 3
	# Set random position
	var rand_x = randf_range(texture_size.x, screen_size.x - texture_size.x)
	var rand_y = randf_range(texture_size.y, screen_size.y - texture_size.y)
	# Set random rotation
	var rand_rotate = randf_range(0, 360)
	cat.rotation_degrees = rand_rotate
	cat.global_position = Vector2(rand_x, rand_y)
	
	# avoid the given Rect2 (highlight) 
	if to_avoid.intersects(cat.rect):
		print_debug(cat.cat_name, " intersects with highlight! Retrying...")
		place_cat(cat, to_avoid)
		return
	# avoid the Rect2 of other cats
	for placed_cat in _placed_cats:
		if placed_cat.intersects(cat.rect):
			print_debug(cat.cat_name, " intersects with another cat! Retrying...")
			place_cat(cat, to_avoid)
			return
	# If there is no more intersections, append them to placed_cats for 
	# checking later
	_placed_cats.append(cat.rect)


func initialize_alley() -> void:
	# Create the cats
	for key in _cat_types.keys():
		var cat = cat_scene.instantiate()
		cat.cat_name = key
		# Set sprite
		cat.sprite = _cat_types[key]["texture"]
		# Set collision polygons
		for poly in _cat_types[key]["collision_polygons"]:
			cat.add_child(poly)
		cats.append(cat)
	
	# Finally, place the cats
	for cat in cats:
		place_cat(cat, _avoid)
		add_child(cat)
