extends TextureRect

var card_value

var i_cursor_selected = load("res://games/match_the_cards/assets/sprites/cursor_selected.png")
var	i_cursor_unselected = load("res://games/match_the_cards/assets/sprites/cursor_unselected.png")
var i_card_front = load("res://games/match_the_cards/assets/sprites/cards/card_empty.png")
var	i_card_back = load("res://games/match_the_cards/assets/sprites/cards/card_back.png")

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
	#if value:
	#	$CenterContainer/Texture.focus_mode = FOCUS_NONE
	card_disabled = value

func _ready() -> void:
	# Set the card image basing from the given card_value
	i_card_front = load("res://games/match_the_cards/assets/sprites/cards/deck/" + card_value + ".png")
	$CenterContainer/Texture.texture = i_card_back
	$CenterContainer/Texture.focus_mode = FOCUS_ALL


func _on_focus_entered():
	self.texture = i_cursor_selected
	card_focus_entered.emit(self)


func _on_focus_exited():
	self.texture = i_cursor_unselected
	card_focus_exited.emit(self)
