class_name Board
extends CanvasLayer

enum CellType {Card, FreeCell, Foundation}

const hard_deal_nbrs: Array[int] = [169, 178, 258, 285, 322, 335, 339, 454, 463, 575, 598, 617, 657, 661, 665, 718, 737, 775, 829, 915, 988, 1025, 1136, 1443, 1483, 1495, 1567, 1600, 1617, 1651, 1661, 1689, 1734, 1941, 2021, 2081, 2240, 2241, 2350, 2563, 2577, 2607, 2670, 2772, 2793, 2802, 2884, 3015, 3130, 3232, 3285, 3289, 3342, 3349, 3496, 3685, 3699, 3772, 3788, 3801, 3973, 4054, 4074, 4257, 4368, 4467, 4540, 4591, 4609, 4625, 4714, 4855, 4941, 4946, 5087, 5157, 5179, 5222, 5254, 5374, 5453, 5463, 5482, 5490, 5514, 5548, 5557, 5624, 5707, 5964, 5979, 6017, 6053, 6139, 6182, 6255, 6343, 6365, 6498, 6501, 6589, 6607, 6673, 6745, 6751, 6768, 6775, 6834, 6918, 7000, 7046, 7047, 7057, 7107, 7160, 7303, 7305, 7346, 7426, 7477, 7600, 7700, 7825, 8005, 8182, 8323, 8436, 8454, 8534, 8591, 8613, 8652, 8678, 8710, 8742, 8749, 8820, 8927, 9102, 9209, 9250, 9278, 9385, 9538, 9617, 9700, 9718, 9784, 9790, 9877, 10288, 10370, 10589, 10660, 10692, 10714, 10955, 11281, 11304, 11386, 11409, 11430, 11677, 11819, 11854, 11944, 11982, 12006, 12021, 12166, 12211, 12313, 12319, 12330, 12381, 12753, 12773, 12795, 13007, 13015, 13304, 13388, 13584, 13751, 13867, 13926, 14027, 14051, 14070, 14188, 14267, 14580, 14623, 14676, 14759, 14762, 14795, 14879, 14904, 14965, 14977, 15023, 15099, 15130, 15133, 15135, 15164, 15227, 15238, 15339, 15382, 15512, 15562, 15695, 15704, 15710, 15746, 15905, 15939, 16129, 16191, 16202, 16407, 16575, 16576, 17277, 17426, 17467, 17524, 17680, 17683, 17736, 17764, 17768, 17863, 17985, 18118, 18192, 18356, 18600, 18623, 18872, 18947, 18992, 19013, 19146, 19410, 19484, 19590, 19633, 19763, 19767, 19837, 19861, 19880, 20055, 20112, 20251, 20418, 20489, 20547, 20581, 20589, 20715, 20725, 20737, 20757, 20810, 20830, 20912, 21051, 21185, 21278, 21454, 21491, 21560, 21785, 21896, 21899, 21939, 22177, 22332, 22369, 22372, 22380, 22521, 22661, 22907, 23156, 23874, 24063, 24104, 24457, 24549, 24591, 24735, 25014, 25123, 25129, 25155, 25246, 25315, 25375, 25424, 25450, 25558, 25599, 25602, 25790, 25856, 25957, 25995, 26061, 26093, 26183, 26194, 26197, 26294, 26369, 26421, 26576, 26629, 26693, 26694, 26710, 27006, 27040, 27188, 27201, 27390, 27938, 28118, 28952, 29001, 29154, 29195, 29198, 29230, 29345, 29435, 29462, 29474, 29580, 29596, 29628, 29676, 29704, 30000, 30057, 30108, 30394, 30414, 30506, 30615, 30663, 30712, 30801, 30887, 30897, 30952, 31044, 31049, 31266, 31302, 31465, 31601, 31631, 31647, 31675, 31706, 31729, 31772, 31918, 31938, 31945]
const easy_deal_nbrs: Array[int] = [2, 5, 7, 8, 11, 26, 30, 33, 37, 38, 51, 54, 56, 58, 59, 77, 79, 85, 87, 91, 94, 97, 98, 99, 103, 104, 105, 109, 113, 116, 134, 144, 150, 151, 155, 163, 164, 166, 173, 179, 180, 186, 195, 198, 892, 1012, 1081, 1150, 1529, 2508, 2514, 3178, 3225, 3250, 4929, 5055, 5152, 5213, 5300, 5814, 5877, 5907, 6749, 6893, 7018, 7058, 7167, 7807, 8355, 8471, 8961, 9998, 10772, 11863, 11987, 12392, 12411, 12676, 13214, 13464, 13532, 14014, 14624, 14826, 15140, 15196, 17772, 17871, 18026, 18150, 18427, 19951, 20533, 21657, 21900, 22663, 23328, 24176, 24919, 25001, 25904, 26719, 27121, 27853, 28856, 30329, 30418, 30584, 30755, 30849, 31185, 31316]

const impossible_nbrs: Array[int] = [11982, 146692, 186216, 455889, 495505, 512118, 517776, 781948]

static var game_timer_scene = preload("res://game_timer.tscn")

class CellInfo:
	var cell_type: CellType
	var cell: Button

@export var foundation: HBoxContainer
@export var freecells: HBoxContainer
@export var tableau: HBoxContainer
@onready var foundation_cells: Array[Node] = foundation.get_children()
@onready var free_cells: Array[Node] = freecells.get_children()
@onready var tableau_cells: Array[Node] = tableau.get_children()
@onready var audio: Node = $/root/Game/Audio

var packed_card = preload("res://card.tscn")
var current_deal_nbr: int
var is_challenge_deal: bool
var move_counter: int
var game_start_time_ms: int
var game_timer: GameTimer
var game_completed: bool
var player_stats: PlayerStats
var player_settings: PlayerSettings

signal new_game_started(deal_nbr: int, is_challenge_deal: bool)
signal card_moved(card: Card, source: Cell, target: Cell)
signal move_counter_changed(move_counter: int)
signal game_won(deal_nbr: int, moves: int, time: int, is_challenge_deal: bool)

func _ready():
	var player_profile = PlayerProfile.get_player_profile()
	player_stats = player_profile.player_stats
	player_settings = player_profile.player_settings
	player_stats.monitor_player_stats(self)
	card_moved.connect(on_card_moved)


func on_cards_dealt(_deal_nbr: int, _is_challenge_deal: bool):
	current_deal_nbr = _deal_nbr
	is_challenge_deal = _is_challenge_deal
						

	game_completed = false
	move_counter = 0
	game_timer = game_timer_scene.instantiate()
	self.add_child(game_timer)
	game_timer.start_timer()

	new_game_started.emit(_deal_nbr, _is_challenge_deal)


func merge_lists():
	print("# before duplicate check: %s" % easy_deal_nbrs.size())
	print("list numbers: %s" % [easy_deal_nbrs])
	print("# hard deal numbers: %s" % [easy_deal_nbrs.size()])

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
		if child.cards.size() < 13:
			return

	game_timer.stop_timer()
	game_completed = true

	if is_challenge_deal:
		Challenge.completed_challenge_deal()
	game_won.emit(current_deal_nbr, move_counter, game_timer.game_time_ms / 1000, is_challenge_deal) 


func _get_matching_child_horizontal(parent: Node, card: Card) -> Cell:
	for child in parent.get_children():
		if child.global_position.x < card.global_position.x + (card.size.x/2) && child.global_position.x + child.size.x > card.global_position.x + (card.size.x/2):
			return child
	return null

