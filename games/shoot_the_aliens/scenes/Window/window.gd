extends Node

@export var difficulty = 1
@export var ufo_scene: PackedScene

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()


func game_over():
	pass
	

func create_ufo(iter: int) -> Path2D:
	# Set points
	var path = Path2D.new()
	iter += 1
	var offset = 64.0
	var p0_vertex = Vector2(0.0, offset * iter)
	var p0_in = Vector2.ZERO
	var p0_out = Vector2(0.0, 0.0)
	var curve = Curve2D.new()
	curve.add_point(p0_vertex, p0_in, p0_out)
	var p1_vertex = Vector2(640.0, offset * iter)
	var p1_in = Vector2(0.0, 0.0)
	var p1_out = Vector2(0.0, 0.0)
	curve.add_point(p1_vertex, p1_in, p1_out)
	var p2_vertex = Vector2(0.0, offset * iter)
	var p2_in = Vector2(0.0, 0.0)
	var p2_out = Vector2.ZERO
	curve.add_point(p2_vertex, p2_in, p2_out)
	path.curve = curve
	
	# Set Path to Follow & Speed
	var path_follow = PathFollow2D.new()
	var enemy_speed = rng.randf_range(100, 200)
	var ufo = ufo_scene.instantiate()
	ufo.speed = enemy_speed
	ufo.path_follow = path_follow
	path_follow.add_child(ufo)
	path.add_child(path_follow)
	return path


func spawn_ufos() -> Array:
	# Default Values
	var num_ufos = 3
	
	var ufos = []
	for n in num_ufos:
		var ufo = create_ufo(n)
		add_child(ufo)
	return ufos

func new_game():
	$AmbientSFX.play()
	spawn_ufos()
	$Player.position = $StartPosition.position
	$Player.show()
