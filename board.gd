class_name Board
extends CanvasLayer

enum CellType {Card, FreeCell, Foundation}

static var game_timer_scene = preload("res://game_timer.tscn")

class CellInfo:
	var cell_type: CellType
	var cell: Button

@export var test_win: bool = false
@export var foundation: HBoxContainer
@export var freecells: HBoxContainer
@export var tableau: HBoxContainer
@export var bottom_bar: HBoxContainer
@export var background: TextureRect
@onready var foundation_cells: Array[Node] = foundation.get_children()
@onready var free_cells: Array[Node] = freecells.get_children()
@onready var tableau_cells: Array[Node] = tableau.get_children()
@onready var audio: Node = $/root/Game/Audio

var packed_card = preload("res://card.tscn")
var current_deal_nbr: int
var deal_type: Deal.Type
var deal_date: String
var move_counter: int
var game_start_time_ms: int
var game_timer: GameTimer
var game_completed: bool
var player_stats: PlayerStats
var player_settings: PlayerSettings

signal new_game_started(deal_nbr: int, deal_type: Deal.Type)
signal card_moved(card: Card, source: Cell, target: Cell)
signal move_counter_changed(move_counter: int)
signal game_won(deal_nbr: int, moves: int, time: int, deal_type: Deal.Type, date: String)

func _ready():
	var player_profile = PlayerProfile.get_player_profile()
	player_stats = player_profile.player_stats
	player_settings = player_profile.player_settings
	player_stats.monitor_player_stats(self)
	card_moved.connect(on_card_moved)
	AudioServer.set_bus_mute(
		AudioServer.get_bus_index("SFX"),
		!player_settings.sound_enabled)
	background.self_modulate = player_settings.background_color

func get_tableau_height() -> int:
	return floor(bottom_bar.global_position.y - tableau.global_position.y) + bottom_bar.size.y

func on_cards_dealt(_deal_nbr: int, _deal_type: Deal.Type, _date: String = ""):
	current_deal_nbr = _deal_nbr
	deal_type = _deal_type
	deal_date = _date

	game_completed = false
	move_counter = 0
	game_timer = game_timer_scene.instantiate()
	self.add_child(game_timer)
	game_timer.start_timer()

	new_game_started.emit(_deal_nbr, _deal_type)


func remove_duplicate_numbers(list: Array[int]) -> Array[int]:
	list.sort()
	var i = 0
	while i < list.size() - 1:
		if list[i] == list[i+1]:
			list.remove_at(i+1)
		else:
			i += 1
	return list


func on_card_moved(_card: Card, _cell: Cell, _target_cell: Cell):
	move_counter += 1
	move_counter_changed.emit(move_counter)
	check_auto_complete(_target_cell)


func check_auto_complete(_target_cell):
	match player_settings.auto_complete:
		PlayerSettings.Autocomplete.ALWAYS:
			check_auto_complete_card()
		PlayerSettings.Autocomplete.ON_FOUNDATION_MOVE:
			if _target_cell.type == Cell.CellType.FoundationCell:
				check_auto_complete_card()
		PlayerSettings.Autocomplete.ONLY_AT_END:
			check_auto_complete_full()
		PlayerSettings.Autocomplete.ASK_AT_END:
			pass
		PlayerSettings.Autocomplete.NEVER:
			pass


func check_auto_complete_full():
	for cell in tableau_cells:
		if !cell.is_cascade_sorted():
			return
	check_auto_complete_card()


func check_auto_complete_card():
	await get_tree().create_timer(0.1).timeout
	var foundation_candidates: Dictionary = {
		Card.Suit.CLUBS: 1,
		Card.Suit.DIAMONDS: 1,
		Card.Suit.HEARTS: 1,
		Card.Suit.SPADES: 1,
	}

	# determine which rank is next for each suit in the foundation
	for cell in foundation_cells:
		if !cell.cards.is_empty():
			foundation_candidates[cell.cards[-1].suit] = cell.cards[-1].rank + 1

	var autocomplete_candidates: Dictionary = foundation_candidates.duplicate()

	# eliminate suits where the next foundation rank is at least 2 higher than the lowest rank for the other color
	for suit in foundation_candidates:
		var rank = foundation_candidates[suit]
		for other_suit in foundation_candidates:
			if Card.get_suit_color(other_suit) != Card.get_suit_color(suit) && foundation_candidates[other_suit] < rank - 1:
				autocomplete_candidates.erase(suit)
				break

	# compose array of tableau and freecells
	var source_cells: Array[Node] = tableau_cells.duplicate()
	source_cells.append_array(free_cells)

	# compare foundation candidates with last card of every cell
	for i in source_cells.size():
		var cell = source_cells[i]
		if !cell.cards.is_empty():
			var card = cell.cards[-1]
			if autocomplete_candidates.has(card.suit) && autocomplete_candidates[card.suit] == card.rank:
				var target_cell: Cell = get_best_available_cell(card)
				if target_cell.type != Cell.CellType.FoundationCell:
					printerr("autocomplete chose a non-fitting card: suit: %s, rank: %r" % [card.suit, card.rank])

				audio.get_node("Foundation").play()
				var old_cell = card.cell
				card.z_index = 100
				old_cell.remove_card(card)
				target_cell.add_card(card)
				card_moved.emit(card, old_cell, target_cell)
				break


func get_target_cell(_card: Card) -> Cell:
	var card_x = _card.global_position.x + (_card.size.x / 2)
	if _card.global_position.y + (_card.size.y / 2) > tableau.position.y:
		return _get_matching_child_horizontal(tableau, _card)

	elif card_x < freecells.position.x + freecells.size.x && card_x > freecells.position.x:
		return _get_matching_child_horizontal(freecells, _card)
	
	elif card_x > foundation.position.x && card_x < foundation.position.x + foundation.size.x:
		return _get_matching_child_horizontal(foundation, _card)

	return null


func get_best_available_cell(_card: Card):
	for cell in foundation_cells:
		if cell.is_card_allowed(_card):
			return cell

	for cell in free_cells:
		if cell.is_card_allowed(_card):
			return cell

	return null
		


func get_freecell_amount() -> int:
	var count: int = 0
	for child in free_cells:
		if child.cards.is_empty():
			count += 1
	for child in tableau_cells:
		if child.cards.is_empty():
			count += 1
	return count

func get_moveable_cascade_size(target_cell: Cell) -> int:
	var freecell_count: int = 0
	for cell in free_cells:
		if cell.cards.is_empty():
			freecell_count += 1
	
	var tableau_count: int = 0
	for cell in tableau_cells:
		if cell.cards.is_empty() && cell != target_cell:
			tableau_count += 1
	
	var cascade_size = 0
	while tableau_count > 0:
		cascade_size += freecell_count + tableau_count
		tableau_count -= 1
	cascade_size += freecell_count

	return cascade_size


func check_game_completed():
	for child in foundation_cells:
		if !test_win && child.cards.size() < 13:
			return

	game_timer.stop_timer()
	game_completed = true

	match deal_type:
		Deal.Type.CHALLENGE:
			Challenge.completed_challenge_deal()
		Deal.Type.DAILY:
			player_stats.daily_deal_completed(deal_date)
	
	game_won.emit(current_deal_nbr, move_counter, floori(game_timer.game_time_ms / 1000.0), deal_type, deal_date) 


func _get_matching_child_horizontal(parent: Node, card: Card) -> Cell:
	for child in parent.get_children():
		if child.global_position.x < card.global_position.x + (card.size.x/2) && child.global_position.x + child.size.x > card.global_position.x + (card.size.x/2):
			return child
	return null
