extends CenterContainer

@export var board: Board

@onready var background = $Background
@onready var congrats = $Content/Congrats
@onready var challenge_progress = $Content/ChallengeProgress
@onready var progress_bar: ProgressBar = $Content/ChallengeProgress/Progress/ProgressBar
@onready var progress_label: Label = progress_bar.get_node("Label")
@onready var level_label: Label = challenge_progress.get_node("Progress/Level")

func _ready():
	self.visible = false
	challenge_progress.visible = false
	board.game_won.connect(on_game_won)

func on_game_won(_game_nbr: int, _moves: int, _time: int, is_challenge_game: bool):

	if is_challenge_game:
		_advance_progress_bar()

	challenge_progress.visible = is_challenge_game

	var background_size = Vector2(congrats.size.x, 0)
	background_size.y = congrats.size.y if !is_challenge_game else congrats.size.y + challenge_progress.size.y
	background.custom_minimum_size = background_size
	self.visible = true

func _input(event):
	if event is InputEventMouseButton:
		self.visible = false

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
	
	

