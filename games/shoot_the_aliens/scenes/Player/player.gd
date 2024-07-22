extends Area2D

@export var speed = 400
@export var laser_speed = 400
@export var laser_scene: PackedScene

var screen_size


func shoot_laser_v1(position):
	$LaserSFX.play()
	var path = Path2D.new()
	var p0_vertex = Vector2(position)
	var p0_in = Vector2.ZERO
	var p0_out = Vector2.ZERO
	var curve = Curve2D.new()
	curve.add_point(p0_vertex, p0_in, p0_out)
	var p1_vertex = Vector2(position.x, 0.0)
	var p1_in = Vector2.ZERO
	var p1_out = Vector2.ZERO
	curve.add_point(p1_vertex, p1_in, p1_out)
	#var p2_vertex = Vector2(0.0, 480.0)
	#var p2_in = Vector2.ZERO
	#var p2_out = Vector2.ZERO
	#curve.add_point(p2_vertex, p2_in, p2_out)
	path.curve = curve
	
	# Set Path to Follow & Speed
	var path_follow = PathFollow2D.new()
	var laser = laser_scene.instantiate()
	laser.speed = laser_speed
	laser.path_follow = path_follow
	path_follow.add_child(laser)
	path_follow
	path.add_child(path_follow)
	add_child(path)
	return path


func shoot_laser(position):
	$LaserSFX.play()
	var laser = laser_scene.instantiate()
	# Add laser to parent so that its instance won't move
	# relative to the player
	self.get_parent().add_child(laser)
	laser.transform = $Muzzle.global_transform


func _ready() -> void:
	screen_size = get_viewport_rect().size
	self.hide()


func _process(delta) -> void:
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		#velocity.y += 1
		pass
	if Input.is_action_pressed("move_up"):
		#velocity.y -= 1
		pass
	if Input.is_action_just_pressed("button0"):
		shoot_laser(position)
	
	# Prevent player from moving faster diagonally
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	# Clamp within the screen
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

