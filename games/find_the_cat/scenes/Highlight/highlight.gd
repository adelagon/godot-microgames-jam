extends Area2D
class_name Highlight

var _circle: CircleShape2D

var _highlight_radius: float
var highlight_radius: float: 
	get:
		return _highlight_radius
	set(value):
		_highlight_radius = value
		_circle = CircleShape2D.new()
		_circle.radius = value
		_rect = _circle.get_rect()
		var collision = CollisionShape2D.new()
		collision.shape = _circle
		add_child(collision)

var _rect: Rect2
var rect: Rect2:
	get:
		return Rect2(global_position, _circle.get_rect().size)

var _enabled = true
var enabled: bool:
	get:
		return _enabled
	set(value):
		_enabled = value
		


func _draw() -> void:
	var white : Color = Color.WHITE
	draw_circle(Vector2.ZERO, highlight_radius, white)


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
