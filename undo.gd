class_name Undo
extends TextureButton

var undo_stack: Array[Move]
@onready var board = $/root/Game/Board

func _ready():
	board.card_moved.connect(on_card_moved)

func on_card_moved(card: Card, source: Cell, target: Cell):
	undo_stack.push_back(Move.new(card, source, target))

func undo():
	var move = undo_stack.pop_back()
	if move != null:
		var i: int = 0
		var child: Card = move.card
		while child != null:
			child.z_index = 100 + i
			child = child.child
			i += 1
		move.target.remove_card(move.card)
		move.source.add_card(move.card)

class Move:
	var card: Card
	var source: Cell
	var target: Cell

	func _init(_card: Card, _source: Cell, _target: Cell):
		card = _card
		source = _source
		target = _target
