class_name Challenge

const lvldeals = [
	[],
	[2, 5, 7, 8, 11],
	[26, 30, 33, 37, 38, 51, 54, 56, 58, 59],
	[1, 3, 4, 6, 9, 10, 12, 13, 14, 15],
	[16, 17, 18, 19, 20, 21, 22, 23, 24, 25],
	[169, 178, 258, 285, 322, 335, 339, 454, 463, 575]
]

static func get_challenge_lvl() -> int:
	return PlayerProfile.get_player_profile().player_stats.challenge_lvl

static func get_challenge_lvl_progress() -> int:
	return PlayerProfile.get_player_profile().player_stats.challenge_lvl_progress

static func get_challenge_lvl_size() -> int:
	var challenge_lvl: int = get_challenge_lvl()
	if challenge_lvl < lvldeals.size():
		return lvldeals[challenge_lvl].size()
	else:
		return 10

static func get_previous_challenge_lvl_size() -> int:
	var challenge_lvl: int = get_challenge_lvl()
	if challenge_lvl - 1 < lvldeals.size():
		return lvldeals[challenge_lvl-1].size()
	else:
		return 10

static func get_next_game() -> int:
	var challenge_lvl: int = get_challenge_lvl()
	if challenge_lvl < lvldeals.size():
		return lvldeals[challenge_lvl][get_challenge_lvl_progress()]
	else:
		return Deal.hard_deal_nbrs[randi() % Deal.hard_deal_nbrs.size()]

static func completed_challenge_deal():
	var stats = PlayerProfile.get_player_profile().player_stats
	stats.challenge_lvl_progress += 1
	if stats.challenge_lvl_progress > get_challenge_lvl_size() - 1:
		stats.challenge_lvl_progress = 0
		stats.challenge_lvl += 1
	PlayerProfile.get_player_profile().player_stats.player_stats_changed.emit()
