extends TextureRect

var card_value
var i_cursor_selected
var	i_cursor_unselected
var i_card_front
var	i_card_back

signal card_focus_entered
signal card_focus_exited

var card_hidden : bool = true
var hide_card : bool = card_hidden: get = _get_card_hidden, set = _set_card_hidden

func _get_card_hidden() -> bool:
	return card_hidden


func _set_card_hidden(value: bool) -> void:
	if value:
		$CenterContainer/Texture.texture = i_card_back
	else:
		$CenterContainer/Texture.texture = i_card_front
	card_hidden = value

var card_disabled : bool = false
var disable_card : bool = card_disabled: get = _get_card_disabled, set = _set_card_disabled

func _get_card_disabled():
	return card_disabled
	
func _set_card_disabled(value: bool):
	card_disabled = value


func load_card_textures() -> void:
	var cursor_selected_res = load("res://games/match_the_cards/assets/sprites/cursor_selected.png")
	i_cursor_selected = ImageTexture.create_from_image(cursor_selected_res.get_image())
	var cursor_unselected_res = load("res://games/match_the_cards/assets/sprites/cursor_unselected.png")
	i_cursor_unselected = ImageTexture.create_from_image(cursor_unselected_res.get_image())
	var card_front_res = load("res://games/match_the_cards/assets/sprites/cards/deck/" + card_value + ".png")
	i_card_front = ImageTexture.create_from_image(card_front_res.get_image())
	var card_back_res = load("res://games/match_the_cards/assets/sprites/cards/card_back.png")
	i_card_back = ImageTexture.create_from_image(card_back_res.get_image())
	$CenterContainer/Texture.texture = i_card_back
	$CenterContainer/Texture.focus_mode = FOCUS_ALL


func _ready() -> void:
	load_card_textures()


func _on_focus_entered():
	self.texture = i_cursor_selected
	card_focus_entered.emit(self)


func _on_focus_exited():
	self.texture = i_cursor_unselected
	card_focus_exited.emit(self)
