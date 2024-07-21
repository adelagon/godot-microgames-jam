extends Area2D
class_name UFO

var speed = 0.0
var initialized = false
var path_follow

var rng = RandomNumberGenerator.new()

signal ufo_hit

func _ready():
	$AnimatedSprite2D.play()


func _process(delta) -> void:
	# Due to lack of good constructor pattern in GDScript, we need to first check
	# if path_follow has been assigned by the parent node. If not set, we wait for
	# the next _process
	if path_follow == null:
		return

	# Set random position of the UFO once path_follow has bee initiliazed
	if path_follow and not initialized:
		initialized = true
		path_follow.progress_ratio = rng.randf_range(0.0, 1.0)

	path_follow.progress += speed * delta

