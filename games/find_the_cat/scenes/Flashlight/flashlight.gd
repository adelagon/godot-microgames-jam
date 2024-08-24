extends Sprite2D

var _enabled = true
var enabled: bool:
	get:
		return _enabled
	set(value):
		_enabled = value


func _process(delta: float) -> void:
	if not _enabled:
		return

	var velocity = Vector2.ZERO
	var speed = 200
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

	# Clamp within the screen
	var screen_size = get_viewport_rect().size
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
