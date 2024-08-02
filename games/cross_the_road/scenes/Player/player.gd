extends Area2D

var speed = 200
var screen_size

var rng = RandomNumberGenerator.new()

var stopped = false
signal player_hit


func _ready() -> void:
	screen_size = get_viewport_rect().size
	$AnimatedSprite2D.play("start")
	$FootstepTimer.start(0.2)


func _process(delta) -> void:
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right") and not stopped:
		velocity.x += 1
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("walk_horizontal")
	if Input.is_action_pressed("move_left") and not stopped:
		velocity.x -= 1
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("walk_horizontal")
	if Input.is_action_pressed("move_down") and not stopped:
		velocity.y += 1
		$AnimatedSprite2D.play("walk_vertical")
	if Input.is_action_pressed("move_up") and not stopped:
		velocity.y -= 1
		$AnimatedSprite2D.play("walk_vertical")

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		if $FootstepTimer.is_stopped():
			$FootstepSFX.pitch_scale = rng.randf_range(0.8, 1.2)
			$FootstepSFX.play()
			$FootstepTimer.start(0.2)
	else:
		$AnimatedSprite2D.stop()
	
	# Clamp within the screen
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)


func _on_area_entered(area) -> void:
	if area.name == "Vehicle":
		$AnimatedSprite2D.play("hit")
		$SplatSFX.play()
		player_hit.emit()
		
	stopped = true
