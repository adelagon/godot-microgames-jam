extends Node
class_name Utils

### Utility functions
static func clamp_texture_to_screen(texture: ImageTexture, parent: Variant):
	var screen_size = parent.get_viewport_rect().size
	var texture_size = texture.get_size()
	var sprite_size = texture_size * parent.get_scale()
	print(screen_size)
	print(texture_size)
	print(sprite_size)
	parent.position = parent.position.clamp(sprite_size / 2, screen_size - sprite_size / 2)


static func load_sprite_directory(dir: String, with_collision: bool = false) -> Dictionary:
	var res = {}
	for file_name in DirAccess.get_files_at(dir):
		if file_name.get_extension() == "import":
			var key = file_name.replace(".png.import", "")
			var fn = file_name.replace(".import", "")
			var image = load(dir + fn).get_image()
			var texture = ImageTexture.create_from_image(image)
			var collision_polygons = []
			if with_collision:
				collision_polygons = get_collision_from_texture(texture)
			res[key] = {
				"texture": texture,
				"collision_polygons": collision_polygons
			}
	return res


static func get_collision_from_texture(texture: ImageTexture) -> Array:
	var image = texture.get_image()
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(image)
	var polys = bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, image.get_size()), 0.0)
	var polygons = []
	for poly in polys:
		var collision_polygon = CollisionPolygon2D.new()
		collision_polygon.polygon = poly
		collision_polygon.position -= texture.get_size() / 2
		polygons.append(collision_polygon)
	return polygons
	

static func is_within_range(from: Node2D, to: Node2D, minimum: float) -> bool:
	if from.global_position.distance_to(to.global_position) <= minimum:
		return true
	return false
### End Utility functions
