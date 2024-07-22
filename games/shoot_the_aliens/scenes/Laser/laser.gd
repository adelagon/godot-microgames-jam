extends Area2D
class_name Laser

var speed = 400


func _ready() -> void:
	print("pew!")


func _physics_process(delta):
	position += -transform.y * speed * delta


func _on_area_exited(area):
	self.queue_free()
