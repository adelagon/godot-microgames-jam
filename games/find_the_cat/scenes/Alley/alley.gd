extends TextureRect

@export var cat_scene: PackedScene
# Defines the largest cat in terms of length (magnitude)
var max_cat_size: float

var all_good = false
var cat_sizes = []
var cats = []
var _cat_types = {}
var cat_types: Dictionary: 
	get:
		return _cat_types
	set(value):
		_cat_types = value
		initialize_alley()
var _highlight: Highlight
var highlight: Highlight:
	get:
		return _highlight
	set(value):
		_highlight = value
		_highlight.global_position = get_viewport_rect().size / 2
		_highlight.connect("area_entered", _on_area_entered)
		_highlight.connect("area_exited", _on_body_entered)
		add_child(_highlight)


func place_cat(cat: Cat) -> void:
	# Bound the cat to certain position basing on texture size
	var screen_size = get_viewport_rect().size
	var texture_size = cat.sprite.get_size() / 2
	cat_sizes.append(texture_size.length())
	var rand_x = randf_range(texture_size.x, screen_size.x - texture_size.x)
	var rand_y = randf_range(texture_size.y, screen_size.y - texture_size.y)
	var rand_rotate = randf_range(0, 360)
	cat.rotation_degrees = rand_rotate
	cat.global_position = Vector2(rand_x, rand_y)


func initialize_alley() -> void:
	for key in _cat_types.keys():
		var cat = cat_scene.instantiate()
		cat.cat_name = key
		# Set sprite
		cat.sprite = _cat_types[key]["texture"]
		# Watch for AreaEntered
		cat.connect("area_entered", _on_area_entered)
		# Set collision polygons
		for poly in _cat_types[key]["collision_polygons"]:
			cat.add_child(poly)
		cats.append(cat)
		place_cat(cat)
		add_child(cat)
	max_cat_size = cat_sizes.max()


func _on_area_entered(area: Area2D):
	if area is Cat and not all_good:
		# Change the cat position if there's a collision with other cats
		# This is to guarantee that they don't overlap
		print_debug("Collision detected, repositioning cat")
		place_cat(area)
	elif area is Highlight:
		print_debug("Highlight collided")

func _on_body_entered(body: Node2D) -> void:
	print("Body Entered: ", body)
	

func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Make sure that there is no overlaps before making the cats visible
	if not all_good:
		for cat in cats:
			print("Overlap :", cat.has_overlapping_areas())
			if cat.has_overlapping_areas():
				place_cat(cat)
				return
		all_good = true
		print_debug("No more overlaps, showing all cats")
		for cat in cats:
			cat.visible = true
