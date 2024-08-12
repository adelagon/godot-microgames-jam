extends TextureRect

@export var cat_scene: PackedScene

var cats = []
var _cat_types = {}
var cat_types: Dictionary: 
	get:
		return _cat_types
	set(value):
		_cat_types = value
		initialize_alley()


func place_cat(cat: Cat, collision_layer: int, collision_mask: int) -> void:
	# Bound the cat to certain position basing on texture size
	var screen_size = get_viewport_rect().size
	var texture_size = cat.sprite.get_size() / 2
	var rand_x = randf_range(texture_size.x, screen_size.x - texture_size.x)
	var rand_y = randf_range(texture_size.y, screen_size.y - texture_size.y)
	var rand_rotate = randf_range(0, 360)
	cat.collision_layer = collision_layer
	cat.collision_mask = 1
	cat.rotation_degrees = rand_rotate
	cat.connect("area_entered", _on_area_entered)
	cat.global_position = Vector2(rand_x, rand_y)
	#print_debug("Cat Name: ", cat.cat_name, " Position: ", cat.global_position)
	#print_debug("Overlaps: ", cat.has_overlapping_areas())
	add_child(cat)


func initialize_alley() -> void:
	var collision_layer = 1
	for key in _cat_types.keys():
		var cat = cat_scene.instantiate()
		cat.cat_name = key
		# Set sprite
		cat.sprite = _cat_types[key]["texture"]
		# Set collision polygons
		for poly in _cat_types[key]["collision_polygons"]:
			cat.add_child(poly)
		cats.append(cat)
		place_cat(cat, 1, 1)
		collision_layer +=  1


func _on_area_entered():
	print("Hi!")

func _ready() -> void:
	initialize_alley()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
