extends Area2D
class_name Highlight

var _highlight_radius: float
var highlight_radius: float: 
	get:
		return _highlight_radius
	set(value):
		_highlight_radius = value
		var circle = CircleShape2D.new()
		circle.radius = value
		var collision = CollisionShape2D.new()
		collision.shape = circle
		add_child(collision)


func _draw() -> void:
	var white : Color = Color.WHITE
	draw_circle(Vector2.ZERO, highlight_radius, white)


func _process(delta: float) -> void:
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
	position += velocity * delta
	#position = position.clamp(Vector2.ZERO, screen_size)
