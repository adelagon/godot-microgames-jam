extends TextureRect

@export var vehicle_scene: PackedScene

var _vehicle_speed = 150
var vehicle_speed: int:
	get:
		return _vehicle_speed
	set(value):
		_vehicle_speed = value
var _max_vehicles_on_screen = 10
var max_vehicles_on_screen: int:
	get:
		return _max_vehicles_on_screen
	set(value):
		_max_vehicles_on_screen = value


var vehicle_textures = []
var vehicles = []

var rng = RandomNumberGenerator.new()

signal player_crossed


func load_vehicle_textures() -> void:
	for file_name in DirAccess.get_files_at("res://games/cross_the_road/assets/sprites/vehicles/"):
		if file_name.get_extension() == "import":
			var fn = file_name.replace(".import", "")
			var loaded_texture = load("res://games/cross_the_road/assets/sprites/vehicles/" + fn)
			var image = loaded_texture.get_image()
			image.resize_to_po2()
			vehicle_textures.append(ImageTexture.create_from_image(image))


func create_vehicle(path: Path2D, randomize_progress: bool = false) -> Area2D:
	var vehicle = vehicle_scene.instantiate()
	if path.name == "Path1":
		vehicle.speed = _vehicle_speed * 2.0
	elif path.name == "Path2":
		vehicle.speed = _vehicle_speed * 1.75
	elif path.name == "Path3":
		vehicle.speed = _vehicle_speed * 1.50
	else:
		vehicle.speed = _vehicle_speed
	vehicle.texture = vehicle_textures.pick_random()
	vehicle.randomize_progress = randomize_progress
	var path_follow = PathFollow2D.new()
	path.add_child(path_follow)
	path_follow.add_child(vehicle)
	vehicle.path_follow = path_follow
	vehicle.connect("vehicle_passed", _on_vehicle_passed)
	return vehicle


func get_random_path() -> Path2D:
	return self.get_children().filter(func(n):
		return n is Path2D).pick_random()


func fill_highway(initial: bool = false) -> void:
	var num_vehicles_needed = _max_vehicles_on_screen - len(vehicles)
	for n in range(num_vehicles_needed):
		var path = get_random_path()
		var vehicle = create_vehicle(path, initial)
		vehicles.append(vehicle)


func _ready() -> void:
	load_vehicle_textures()
	fill_highway(true)


func _on_vehicle_passed(vehicle: Area2D) -> void:
	vehicle.get_parent().queue_free()
	vehicles.erase(vehicle)


func _process(_delta) -> void:
	fill_highway()


func _on_finish_line_area_entered(_area) -> void:
	player_crossed.emit()
