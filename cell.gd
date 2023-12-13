class_name Cell
extends TextureRect

enum CellType {FreeCell, FoundationCell, TableauCell}

const cascade_space = 36

@export var type: CellType
var cards: Array[Card] 

@onready var board: Board = $/root/Game/Board

func add_card(card: Card, automove: bool = false):
	while card != null:
		var original_position = card.global_position
		card.get_parent().remove_child(card)
		add_child(card)
		card.global_position = original_position
		if !cards.is_empty():
			cards.back().child = card
		if type == CellType.TableauCell:
			#card.global_position = self.global_position + Vector2(0,cards.size() * cascade_space)
			card.automove(self.global_position + Vector2(0, cards.size() * cascade_space))
		else:
			#card.global_position = self.global_position
			card.automove(self.global_position)
		card.cell = self
		cards.append(card)
		card = card.child

	if type == CellType.FoundationCell:
		board.check_game_completed()
	
func automove_complete(card: Card):
	card.z_index = cards.find(card) + 1


func remove_card(card: Card):
	if cards.is_empty():
		printerr("Trying to remove card from empty cell")
		return

	var index = cards.size() - 1
	while cards[index] != card:
		index -= 1
	
	while index < cards.size():
		cards.pop_back()

	if !cards.is_empty():
		cards.back().child = null

func clear():
	for card in cards:
		card.queue_free()
	cards.clear()


func is_card_allowed(card: Card) -> bool:
	match type:
		CellType.FreeCell:
			return cards.is_empty() && card.child == null
		CellType.FoundationCell:
			if card.child != null:
				return false
			elif cards.is_empty():
				return card.rank == 1
			else:
				var top_card = cards[-1]
				return (top_card.suit == card.suit && top_card.rank == card.rank - 1)
		CellType.TableauCell:
			if !card.is_legal_cascade():
				return false
			var freecell_amount = board.get_moveable_cascade_size(self)
			#if self.cards.is_empty():
			#	freecell_amount -= 1
			if freecell_amount < card.get_cascade_size() - 1:
				return false
			else:
				if cards.is_empty():
					return true
				else: 
					var top_card = cards[-1]
					return Card.get_suit_color(top_card.suit) != Card.get_suit_color(card.suit) && top_card.rank == card.rank + 1
	return false

func is_cascade_sorted() -> bool:
	for i in cards.size() - 1:
		if cards[i].rank < cards[i+1].rank:
			return false
	return true

func get_next_rank() -> int:
	if cards.is_empty():
		return 1
	else:
		return cards[-1].rank + 1

