extends TextureRect

@export var card_scene: PackedScene

var deck = []
var played_cards = []
var num_pairs : int = 2 # min=2, max=15
var pairs : int = num_pairs: get = _get_num_pairs, set = _set_num_pairs
func _get_num_pairs() -> int:
	return num_pairs
	
func _set_num_pairs(value: int) -> void:
	num_pairs = value
	initialize_table(value)


func load_deck() -> void:
	for file_name in DirAccess.get_files_at("res://games/match_the_cards/assets/sprites/cards/deck/"):
		if file_name.get_extension() == "png":
			var fn = file_name.replace(".png", "")
			deck.append(fn)


func create_card(card_value: String) -> TextureRect:
	var card = card_scene.instantiate()
	card.card_value = card_value
	return card


func initialize_table(num_pairs: int):
	# Select cards at random
	var card_selection = deck
	card_selection.shuffle()
	for card_value in card_selection.slice(0, num_pairs):
		# Add two of a kind
		played_cards.append(create_card(card_value))
		played_cards.append(create_card(card_value))
		played_cards.shuffle()
	
	# Set table and maximize the spacing
	$TableContainer/CardGridContainer.columns = ceil(sqrt(num_pairs*2))
	for card in played_cards:
		$TableContainer/CardGridContainer.add_child(card)
	played_cards[0].get_node("%Texture").grab_focus()


func _ready() -> void:
	load_deck()

