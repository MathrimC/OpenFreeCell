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

signal player_stats_changed()

func _init():
	challenge_lvl = 1

func monitor_player_stats(board: Board):
	board.new_game_started.connect(on_new_game_started)
	board.game_won.connect(on_game_won)	

func on_new_game_started(_deal_nbr: int, _is_challenge_deal: bool):
	games_started += 1
	player_stats_changed.emit()

func on_game_won(deal_nbr: int, moves: int, time_s: int, _is_challenge_deal: bool):
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

