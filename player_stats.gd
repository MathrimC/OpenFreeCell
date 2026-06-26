class_name PlayerStats
extends Resource

@export var games_started: int
@export var games_won: int
@export var hard_deals_won: Array[int]

@export var shortest_deal_nbr: int
@export var shortest_game_moves: int

@export var fastest_deal_nbr: int
@export var fastest_game_time_s: int

@export var challenge_lvl: int
@export var challenge_lvl_progress: int

@export var daily_deal_streak: int
@export var daily_deals_won: int
@export var solved_dates: Array[int]

signal player_stats_changed()

func _init() -> void:
	challenge_lvl = 1

func monitor_player_stats(board: Board) -> void:
	board.new_game_started.connect(on_new_game_started)
	board.game_won.connect(on_game_won)	

func on_new_game_started(_deal_nbr: int, _deal_type: Deal.Type) -> void:
	games_started += 1
	player_stats_changed.emit()

func on_game_won(deal_nbr: int, moves: int, time_s: int, _deal_type: Deal.Type, _date: String) -> void:
	games_won += 1
	if moves < shortest_game_moves || shortest_game_moves == 0:
		shortest_deal_nbr = deal_nbr
		shortest_game_moves = moves
	if time_s < fastest_game_time_s || fastest_game_time_s == 0:
		fastest_deal_nbr = deal_nbr
		fastest_game_time_s = time_s
	if Board.hard_deal_nbrs.has(deal_nbr) && !hard_deals_won.has(deal_nbr):
		hard_deals_won.append(deal_nbr)
	player_stats_changed.emit()

func daily_deal_completed(_date: String) -> void:
	var last_solve := solved_dates[-1] if !solved_dates.is_empty() else 0
	var new_solve := int(_date)
	if last_solve != new_solve:
		daily_deals_won += 1
	var unix_time := Time.get_unix_time_from_datetime_string("%sT12:00:00" % _date)
	var yesterday := Time.get_date_string_from_unix_time(unix_time - 24*3600)
	if last_solve == int(yesterday):
		daily_deal_streak += 1
	else:
		daily_deal_streak = 1
	solved_dates.append(new_solve)
	player_stats_changed.emit()


func refresh_daily_streak() -> void:
	if daily_deal_streak > 0:
		var today := Time.get_date_string_from_system()
		var unix_time := Time.get_unix_time_from_datetime_string("%sT12:00:00" % today)
		var yesterday := Time.get_date_string_from_unix_time(unix_time - 24*3600)
		if int(yesterday) > solved_dates[-1]:
			daily_deal_streak = 0
			player_stats_changed.emit()
