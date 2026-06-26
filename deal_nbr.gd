extends Label

@onready var board: Board = $/root/Game/Board

func _ready():
	board.new_game_started.connect(on_new_game_started)

func on_new_game_started(deal_nbr: int, _deal_type: Deal.Type):
	self.text = "%s" % deal_nbr


