extends Area2D
#class_name Laser

var speed = 400


func _physics_process(delta) -> void:
	position += -transform.y * speed * delta


func _on_area_exited(_area: Area2D) -> void:
	self.queue_free()
