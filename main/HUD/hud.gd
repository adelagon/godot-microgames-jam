extends Node2D


func set_message(message: String) -> void:
	$MessageContainer/Message.set_text(message)


func set_lives(lives: int) -> void:
	$LivesContainer/Lives.set_text("Lives: %d" % lives)
