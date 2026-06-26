extends CenterContainer

@export var board: Board

@export var congrats: Label
@export var challenge_progress: Container
@export var progress_bar: ProgressBar
@export var progress_label: Label
@export var level_label: Label
@export var streak: Label

func _ready():
	self.visible = false
	challenge_progress.visible = false
	board.game_won.connect(on_game_won)

func on_game_won(_game_nbr: int, _moves: int, _time: int, _deal_type: Deal.Type, _date: String):
	challenge_progress.hide()
	streak.hide()
	match _deal_type:
		Deal.Type.CHALLENGE:
			_advance_progress_bar()
			challenge_progress.show()
		Deal.Type.DAILY:
			streak.text = "%d day streak" % board.player_stats.daily_deal_streak
			streak.show()
	self.show()

func _input(event):
	if event is InputEventMouseButton:
		self.hide()

func _advance_progress_bar():
	var target_progress: int = Challenge.get_challenge_lvl_progress()
	var target_level: int = Challenge.get_challenge_lvl()
	var lvl_up: bool = false

	if target_progress > 0:
		progress_bar.max_value = Challenge.get_challenge_lvl_size()
	else:
		lvl_up = true
		target_progress = Challenge.get_previous_challenge_lvl_size()
		progress_bar.max_value = target_progress
		target_level -= 1

	progress_bar.value = target_progress - 1
	progress_label.text = "%s/%s" % [target_progress - 1, progress_bar.max_value as int]
	level_label.text = "Level %s" % target_level
	
	while progress_bar.value < target_progress:
		progress_bar.value += 0.02
		var updated_label = false
		if !updated_label && target_progress - progress_bar.value < 0.7:
			progress_label.text = "%s/%s" % [target_progress, progress_bar.max_value as int]
			updated_label = true
		await get_tree().create_timer(0.02).timeout
	
	if lvl_up:
		progress_bar.max_value = Challenge.get_challenge_lvl_size()
		progress_bar.value = 0
		progress_label.text = "%s/%s" % [0, progress_bar.max_value as int]
		level_label.text = "Level %s" % (target_level + 1)
	
	
