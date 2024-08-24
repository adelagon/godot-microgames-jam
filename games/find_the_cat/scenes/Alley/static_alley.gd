extends TextureRect

var _cats = []
var cats: Array:
	get:
		return _cats
	set(value):
		_cats = value
		place_cats(value)


func place_cats(value):
	for cat in value:
		add_child(cat.duplicate())
