extends Area2D

@export var speed = 400
@export var laser_speed = 400
@export var laser_scene: PackedScene

var screen_size
var disable_movement = false


func shoot_laser():
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
	if disable_movement:
		return
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_just_pressed("button0"):
		shoot_laser()
	
	# Prevent player from moving faster diagonally
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	# Clamp within the screen
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

