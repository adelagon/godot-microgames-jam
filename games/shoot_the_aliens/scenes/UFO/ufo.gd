extends Area2D
class_name UFO

var speed = 0.0
var initialized = false
var hit = false
var path_follow

var rng = RandomNumberGenerator.new()

signal ufo_hit

func _ready() -> void:
	$AnimatedSprite2D.play("default")


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

	# Proceed with the path
	path_follow.progress += speed * delta
	
	
	if $AnimatedSprite2D.animation == "explode":
		print("exploded")


func _on_area_entered(_area) -> void:
	# Ignore if already hit
	if hit:
		return
	# this should pause the path follow
	path_follow = null
	# play the explosion animation once
	$AnimatedSprite2D.play("explode")
	$AnimatedSprite2D.connect("animation_looped", self._on_animation_looped)
	$HitSFX.play()
	hit = true
	ufo_hit.emit(self.get_instance_id())


func _on_animation_looped() -> void:
	# Delete Node once explosion animation finished
	if $AnimatedSprite2D.animation == "explode":
		self.queue_free()
