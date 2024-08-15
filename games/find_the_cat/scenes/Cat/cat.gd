extends Area2D
class_name Cat

var _sprite
var sprite: ImageTexture:
	get:
		return _sprite
	set(value):
		_sprite = value
		$Sprite2D.texture = value

var _cat_name
var cat_name: String:
	get:
		return _cat_name
	set(value):
		_cat_name = value

var _size
var size: Vector2i: 
	get:
		return $Sprite2D.texture.get_size()

var speed = 5.0
func _physics_process(delta) -> void:
	pass
	#position += -transform.y * speed * delta


func _ready() -> void:
	pass
	#visible = false


func _process(delta: float) -> void:
	pass
