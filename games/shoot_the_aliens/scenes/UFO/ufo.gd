extends Area2D
class_name UFO

var speed = 0.0
var path_follow


func _ready():
	print("ready")
	$AnimatedSprite2D.play()


func _process(delta):
	if path_follow != null:
		path_follow.progress += speed * delta
	

func _on_visible_on_screen_notifier_2d_screen_exited():
	pass
	#queue_free()
