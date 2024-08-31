extends Control
class_name TransitionPage

@export var life_scene: PackedScene

var message: String:
	get:
		return message
	set(value):
		%Message.text = value

var lives: int:
	get:
		return lives
	set(value):
		lives = value
		if %LivesContainer.get_child_count() == lives:
			return
		for child in %LivesContainer.get_children():
			%LivesContainer.remove_child(child)
		for i in lives:
			var life = life_scene.instantiate()
			%LivesContainer.add_child(life)
