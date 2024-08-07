extends Microgame

var num_pairs
var matched_pairs = 0
var selected_card # card that currently has the focus
var latest_card   # the latest card that was flipped
var previous_card # the previous card that was flipped

### Overrides
func _ready() -> void:
	# Set the table
	num_pairs = difficulty.get("num_pairs", 2)
	$Table.pairs = num_pairs
	var cards = $Table/TableContainer/CardGridContainer.get_children()
	# Set focus to the first card
	selected_card = cards[0]
	for card in cards:
		card.connect("card_focus_entered", _on_card_selected)
		card.connect("card_focus_exited", _on_card_unselected)
	new_game()


func game_over(_meta: Dictionary = {}) -> void:
	won = true
	super.game_over({"score": matched_pairs})
### End Overrides


### Game logic
func _on_card_selected(card: TextureRect) -> void:
	selected_card = card


func _on_card_unselected(_card: TextureRect) -> void:
	pass


func _process(_delta) -> void:
	if Input.is_action_just_pressed("button0"):
		# Ignore if selected card is already disabled
		$SFXMove.play()
		if selected_card.disable_card:
			return
		# Show Selected Card
		selected_card.hide_card = false
		if latest_card == null:
			latest_card = selected_card
			return
		# Ignore if selected_card is already the latest
		if selected_card == latest_card:
			return

		# Update previous & latest cards
		previous_card = latest_card
		latest_card = selected_card

		if previous_card.card_value == latest_card.card_value:
			latest_card.hide_card = false
			latest_card.disable_card = true
			latest_card = null
			previous_card.hide_card = false
			previous_card.disable_card = true
			previous_card = null
			matched_pairs += 1
			$SFXMatch.play()
			if matched_pairs == num_pairs:
				game_over()
		else:
			previous_card.hide_card = true
			$SFXMismatch.play()



