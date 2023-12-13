extends HBoxContainer

@export var board: Board
@onready var move_label: Label = $MoveCounter/Moves
@onready var timer: Label = $Timer/Time

var game_timer: GameTimer
var game_counter: int

func _ready():
	board.new_game_started.connect(on_new_game_started)
	board.move_counter_changed.connect(on_move_counter_changed)
	game_counter = 0

func on_move_counter_changed(move_counter: int):
	move_label.text = "%s" % move_counter

func on_new_game_started(_game_nbr: int, _is_challenge_deal: bool):
	game_timer = board.game_timer
	game_counter += 1
	move_label.text = "0"
	display_timer(game_counter)

func display_timer(_game_counter: int):
	while !board.game_completed && _game_counter == game_counter:
		var time_passed_s: int = game_timer.game_time_ms / 1000
		var minutes: int = time_passed_s / 60
		var seconds: int = time_passed_s % 60
		timer.text = "%s:%02d" % [minutes, seconds]
		await get_tree().create_timer(1).timeout
	
