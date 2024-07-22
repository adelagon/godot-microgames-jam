extends ParallaxBackground

var scroll_speed = 100


func _process(delta) -> void:
	scroll_base_offset += Vector2(0, scroll_speed) * delta
