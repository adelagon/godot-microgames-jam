extends Microgame

@export var ufo_scene: PackedScene

var ufos = []
var num_ufos = 2
var min_ufo_speed = 50
var max_ufo_speed = 100
var score = 0

var rng = RandomNumberGenerator.new()
var game_ended = false


### Overrides
func game_over(_meta: Dictionary = {}) -> void:
	if not game_ended:
		game_ended = true
		$Player.disable_movement = true
		if won:
			$WonSFX.play()
		else:
			$LostSFX.play()
		super.game_over({"score": score})


func new_game() -> void:
	$AmbientSFX.play()
	spawn_ufos()
	$Player.position = $StartPosition.position
	$Player.show()
	super.new_game()
### End Overrides

### Game logic
func _ready() -> void:
	new_game()


func _on_ufo_hit(instance_id: int) -> void:
	ufos.erase(instance_id)
	score += 1
	if not ufos:
		won = true
		game_over()


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
	var ufo_speed = rng.randf_range(min_ufo_speed, max_ufo_speed)
	var ufo = ufo_scene.instantiate()
	ufo.speed = ufo_speed
	ufo.path_follow = path_follow
	ufo.connect("ufo_hit", self._on_ufo_hit)
	ufos.append(ufo.get_instance_id())
	path_follow.add_child(ufo)
	path.add_child(path_follow)
	return path


func spawn_ufos() -> Array:
	# Default Values
	print(difficulty)
	num_ufos = difficulty.get("num_ufos", 2)
	min_ufo_speed = difficulty.get("min_ufo_speed", 100)
	max_ufo_speed = difficulty.get("max_ufo_speed", 200)

	for n in num_ufos:
		var ufo = create_ufo(n)
		add_child(ufo)
	return ufos




