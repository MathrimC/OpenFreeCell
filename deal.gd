class_name Deal

const hard_deal_nbrs: Array[int] = [169, 178, 258, 285, 322, 335, 339, 454, 463, 575, 598, 617, 657, 661, 665, 718, 737, 775, 829, 915, 988, 1025, 1136, 1443, 1483, 1495, 1567, 1600, 1617, 1651, 1661, 1689, 1734, 1941, 2021, 2081, 2240, 2241, 2350, 2563, 2577, 2607, 2670, 2772, 2793, 2802, 2884, 3015, 3130, 3232, 3285, 3289, 3342, 3349, 3496, 3685, 3699, 3772, 3788, 3801, 3973, 4054, 4074, 4257, 4368, 4467, 4540, 4591, 4609, 4625, 4714, 4855, 4941, 4946, 5087, 5157, 5179, 5222, 5254, 5374, 5453, 5463, 5482, 5490, 5514, 5548, 5557, 5624, 5707, 5964, 5979, 6017, 6053, 6139, 6182, 6255, 6343, 6365, 6498, 6501, 6589, 6607, 6673, 6745, 6751, 6768, 6775, 6834, 6918, 7000, 7046, 7047, 7057, 7107, 7160, 7303, 7305, 7346, 7426, 7477, 7600, 7700, 7825, 8005, 8182, 8323, 8436, 8454, 8534, 8591, 8613, 8652, 8678, 8710, 8742, 8749, 8820, 8927, 9102, 9209, 9250, 9278, 9385, 9538, 9617, 9700, 9718, 9784, 9790, 9877, 10288, 10370, 10589, 10660, 10692, 10714, 10955, 11281, 11304, 11386, 11409, 11430, 11677, 11819, 11854, 11944, 11982, 12006, 12021, 12166, 12211, 12313, 12319, 12330, 12381, 12753, 12773, 12795, 13007, 13015, 13304, 13388, 13584, 13751, 13867, 13926, 14027, 14051, 14070, 14188, 14267, 14580, 14623, 14676, 14759, 14762, 14795, 14879, 14904, 14965, 14977, 15023, 15099, 15130, 15133, 15135, 15164, 15227, 15238, 15339, 15382, 15512, 15562, 15695, 15704, 15710, 15746, 15905, 15939, 16129, 16191, 16202, 16407, 16575, 16576, 17277, 17426, 17467, 17524, 17680, 17683, 17736, 17764, 17768, 17863, 17985, 18118, 18192, 18356, 18600, 18623, 18872, 18947, 18992, 19013, 19146, 19410, 19484, 19590, 19633, 19763, 19767, 19837, 19861, 19880, 20055, 20112, 20251, 20418, 20489, 20547, 20581, 20589, 20715, 20725, 20737, 20757, 20810, 20830, 20912, 21051, 21185, 21278, 21454, 21491, 21560, 21785, 21896, 21899, 21939, 22177, 22332, 22369, 22372, 22380, 22521, 22661, 22907, 23156, 23874, 24063, 24104, 24457, 24549, 24591, 24735, 25014, 25123, 25129, 25155, 25246, 25315, 25375, 25424, 25450, 25558, 25599, 25602, 25790, 25856, 25957, 25995, 26061, 26093, 26183, 26194, 26197, 26294, 26369, 26421, 26576, 26629, 26693, 26694, 26710, 27006, 27040, 27188, 27201, 27390, 27938, 28118, 28952, 29001, 29154, 29195, 29198, 29230, 29345, 29435, 29462, 29474, 29580, 29596, 29628, 29676, 29704, 30000, 30057, 30108, 30394, 30414, 30506, 30615, 30663, 30712, 30801, 30887, 30897, 30952, 31044, 31049, 31266, 31302, 31465, 31601, 31631, 31647, 31675, 31706, 31729, 31772, 31918, 31938, 31945]
const easy_deal_nbrs: Array[int] = [2, 5, 7, 8, 11, 26, 30, 33, 37, 38, 51, 54, 56, 58, 59, 77, 79, 85, 87, 91, 94, 97, 98, 99, 103, 104, 105, 109, 113, 116, 134, 144, 150, 151, 155, 163, 164, 166, 173, 179, 180, 186, 195, 198, 892, 1012, 1081, 1150, 1529, 2508, 2514, 3178, 3225, 3250, 4929, 5055, 5152, 5213, 5300, 5814, 5877, 5907, 6749, 6893, 7018, 7058, 7167, 7807, 8355, 8471, 8961, 9998, 10772, 11863, 11987, 12392, 12411, 12676, 13214, 13464, 13532, 14014, 14624, 14826, 15140, 15196, 17772, 17871, 18026, 18150, 18427, 19951, 20533, 21657, 21900, 22663, 23328, 24176, 24919, 25001, 25904, 26719, 27121, 27853, 28856, 30329, 30418, 30584, 30755, 30849, 31185, 31316]
const impossible_nbrs: Array[int] = [11982, 146692, 186216, 455889, 495505, 512118, 517776, 781948]

const packed_card = preload("res://card.tscn")

static func challenge_deal(board: Board) -> int:
	var deal_nbr: int = Challenge.get_next_game()
	_deal(board, Challenge.get_next_game())
	board.on_cards_dealt(deal_nbr, true)
	return deal_nbr


static func random_deal(board: Board) -> int:
	var deal_nbr: int

	var player_settings = PlayerProfile.get_player_profile().player_settings
	match player_settings.difficulty:
		PlayerSettings.Difficulty.Any:
			deal_nbr = (randi() % player_settings.max_deal_nbr) + 1
		PlayerSettings.Difficulty.Easy:
			deal_nbr = easy_deal_nbrs[randi() % easy_deal_nbrs.size()]
		PlayerSettings.Difficulty.Hard:
			deal_nbr = hard_deal_nbrs[randi() % hard_deal_nbrs.size()]
	_deal(board, deal_nbr)
	board.on_cards_dealt(deal_nbr, false)

	return deal_nbr


static func custom_deal(board: Board, deal_nbr: int):
	_deal(board, deal_nbr)
	board.on_cards_dealt(deal_nbr, false)


static func redeal(board: Board):
	_deal(board, board.current_deal_nbr)
	board.on_cards_dealt(board.current_deal_nbr, board.is_challenge_deal)


static func _deal(board: Board, deal_nbr: int):
	for cell in board.free_cells:
		cell.clear()
	for cell in board.foundation_cells:
		cell.clear()
	for cell in board.tableau_cells:
		cell.clear()

	var cards_left = 52
	var column = 0

	var pseudo_rng = PseudoRNG.new()
	pseudo_rng.set_seed(deal_nbr)

	var deck: Array[int] = []
	deck.resize(52)
	for i in 52:
		deck[i] = i

	while cards_left > 0:
		#var rand_index = randi() % cards_left
		var rand_index = pseudo_rng.get_number() % cards_left
		var card_nbr = deck[rand_index]
		deck[rand_index] = deck[-1]
		deck.pop_back()
		var card = packed_card.instantiate()
		board.tableau_cells[column].add_child(card)
		var rank = (card_nbr / 4) + 1
		var suit = card_nbr % 4
		card.init(suit,rank,board.tableau_cells[column])

		column = (column + 1) % board.tableau_cells.size()
		cards_left -= 1	

