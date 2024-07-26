extends Area2D

var path_follow
var texture
var initialized = false
var randomize_progress = false
var speed = 200

var rng = RandomNumberGenerator.new()

signal vehicle_passed


func set_texture_with_collision(texture: ImageTexture) -> void:
	$Sprite.texture = texture
	var image = texture.get_image()
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(image)
	var polys = bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, image.get_size()), 0.0)
	for poly in polys:
		var collision_polygon = CollisionPolygon2D.new()
		collision_polygon.polygon = poly
		add_child(collision_polygon)
		collision_polygon.position -= $Sprite.texture.get_size() / 2


func _ready():
	pass


func _process(delta):
	# Due to lack of good constructor pattern in GDScript, we need to first check
	# if path_follow & texture has been assigned by the parent node. If not set,
	# we wait for the next _process
	if texture == null:
		return
	else:
		if not $Sprite.texture:
			set_texture_with_collision(texture)
			return
	
	if path_follow == null:
		return


	if path_follow and texture and not initialized:
		initialized = true
		path_follow.loop = false
		if randomize_progress:
			path_follow.progress_ratio = rng.randf_range(0.0, 1.0)

	# Emit once path has been completed
	if path_follow.progress_ratio == 1:
		vehicle_passed.emit(self)

	# Proceed with the path
	path_follow.progress += speed * delta
