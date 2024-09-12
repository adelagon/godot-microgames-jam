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

var size: Vector2i: 
	get:
		return $Sprite2D.texture.get_size()

var rect: Rect2:
	get:
		return Rect2(position, size)
		

var meow:
	get:
		$Meow.play()
