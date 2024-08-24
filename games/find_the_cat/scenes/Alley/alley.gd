extends TextureRect

@export var cat_scene: PackedScene
# temporary storage of cat texture sizes
var _cat_sizes = []
# List of all Rect2 of cats that has been properly positioned
var _placed_cats = []
# Selected Cat to find
var _hunted_cat = Cat

# Fires whenever the distance between the highlight and the hunted_cat changes
signal cat_found

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
var hunted_cat: Cat:
	get:
		return _hunted_cat
	set(value):
		_hunted_cat = value
var _highlight: Highlight
var highlight: Highlight:
	get:
		return _highlight
	set(value):
		_highlight = value
		_highlight.global_position = get_viewport_rect().size / 2
		add_child(_highlight)



func get_max_cat_size(cats: Array) -> float:
	for cat in cats:
		var texture_size = cat.sprite.get_size() / 2
		_cat_sizes.append(texture_size.length())
	return _cat_sizes.max()


func place_cat(cat: Cat, avoid: Rect2) -> void:
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
	if avoid.intersects(cat.rect):
		print_debug(cat.cat_name, " intersects with highlight! Retrying...")
		place_cat(cat, avoid)
		return
	# avoid the Rect2 of other cats
	for placed_cat in _placed_cats:
		if placed_cat.intersects(cat.rect):
			print_debug(cat.cat_name, " intersects with another cat! Retrying...")
			place_cat(cat, avoid)
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
	
	# Create the highlight
	highlight = Highlight.new()
	highlight.global_position = get_viewport_rect().size / 2
	highlight.highlight_radius = get_max_cat_size(cats)
	add_child(highlight)
	
	# Finally, place the cats
	for cat in cats:
		place_cat(cat, highlight.rect)
		add_child(cat)

	hunted_cat = cats.pick_random()
	print_debug("Highlight and Cats positioned. Find the cat named: ", hunted_cat.cat_name)


func _ready() -> void:
	pass


func _on_cat_found() -> void:
	# Disabled the highlight movement
	highlight.enabled = false
	# Center the highlight to the hunted cat
	highlight.global_position = hunted_cat.global_position
	cat_found.emit()


func _process(delta: float) -> void:
	# Check the distance between the hunted_cat and the highlight
	# the minimum distance is based on 75% of highlight's radius
	if Utils.is_within_range(hunted_cat, highlight, highlight.highlight_radius * 0.75):
		_on_cat_found()
