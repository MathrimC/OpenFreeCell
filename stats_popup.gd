extends Control

@export var games_started: Label
@export var games_won: Label
@export var shortest_win_deal: Label
@export var shortest_win_moves: Label
@export var fastest_win_deal: Label
@export var fastest_win_time: Label
@export var hard_game_progress: Label
@export var challenge_level: Label
@export var challenge_progress_bar: ProgressBar
@export var challenge_progress_label: Label

func _ready():
	self.visible = false

func open():
	refresh_stats()
	self.visible = true

func close():
	self.visible = false

func refresh_stats():
	var stats = PlayerProfile.get_player_profile().player_stats
	games_started.text = "%s" % stats.games_started
	games_won.text = "%s" % stats.games_won
	shortest_win_deal.text = "Deal #%s" % stats.shortest_deal_nbr
	shortest_win_moves.text = "%s moves" % stats.shortest_game_moves
	fastest_win_deal.text = "Deal #%s" % stats.fastest_deal_nbr
	fastest_win_time.text = "%s:%02d" % [stats.fastest_game_time_s / 60, stats.fastest_game_time_s % 60]
	hard_game_progress.text = "%s/%s" % [stats.hard_deals_won.size(), Board.hard_deal_nbrs.size()]
	challenge_level.text = "Lvl %s" % Challenge.get_challenge_lvl()
	challenge_progress_bar.max_value = Challenge.get_challenge_lvl_size()
	challenge_progress_bar.value = Challenge.get_challenge_lvl_progress()
	challenge_progress_label.text = "%s/%s" % [Challenge.get_challenge_lvl_progress(), Challenge.get_challenge_lvl_size()]


func _input(event: InputEvent):
	if event is InputEventMouseButton:
		self.close()
