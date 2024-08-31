extends Control
class_name MainMenu

signal on_menu_button_pressed


func _on_menu_button_pressed(value: String) -> void:
	if value == "new_game":
		$CenterContainer/MenuContainer.hide()
		$CenterContainer/DifficultyContainer.show()
	else:
		on_menu_button_pressed.emit(value)


func _on_difficulty_selection(value: String) -> void:
	on_menu_button_pressed.emit("new_game", {"difficulty": value})
