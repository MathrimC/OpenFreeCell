class_name PlayerSettings
extends Resource

enum Difficulty {Any, Easy, Hard}
enum Autocomplete {ALWAYS, ON_FOUNDATION_MOVE, ONLY_AT_END, ASK_AT_END, NEVER}

@export var difficulty: Difficulty
@export var max_deal_nbr: int
@export var auto_complete: Autocomplete
@export var background_color: Color

signal player_settings_changed()

func _init():
	difficulty = Difficulty.Any
	max_deal_nbr = 1000000
	auto_complete = Autocomplete.ON_FOUNDATION_MOVE
	background_color = Color(0, 0.251, 0) 
