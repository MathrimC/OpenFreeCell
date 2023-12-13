class_name Card
extends Button

enum Suit {CLUBS, DIAMONDS, HEARTS, SPADES}
enum SuitColor {RED, BLACK}

const automove_speed = 2500 # pixels / second
const automove_fps = 50
var placeholder: int

var suit: Suit
var rank: int

var child: Card
var cell: Cell
var previous_position: Vector2
var previous_z_index: int
var double_clicked: bool
@onready var board: Board = $/root/Game/Board
@onready var audio: Node = $/root/Game/Audio
@onready var sprite: CardSprite = $CardSprite


func init(_suit: Suit, _rank: int, _cell: Cell):
	suit = _suit
	rank = _rank
	cell = _cell
	sprite.set_card_sprite(CardSprite.Type.Solitaire, suit, rank)
	cell.add_card(self)

func _on_button_down():
	start_dragging(0)

func start_dragging(index: int):
	previous_position = self.position
	previous_z_index = self.z_index
	self.z_index = 100 + index
	if child != null:
		child.start_dragging(index + 1)

func restore_position():
	self.position = previous_position
	self.z_index = previous_z_index
	if child != null:
		child.restore_position()

func _on_button_up():
	var target_cell
	if double_clicked:
		double_clicked = false
		target_cell = board.get_best_available_cell(self)
	else:
		target_cell = board.get_target_cell(self)

	if target_cell != null && target_cell.is_card_allowed(self):
		if target_cell.type == Cell.CellType.FoundationCell:
			audio.get_node("Foundation").play()
		else:
			audio.get_node("Snap").play()
		var old_cell = cell
		cell.remove_card(self)
		target_cell.add_card(self)
		board.card_moved.emit(self, old_cell, target_cell)
	else:
		audio.get_node("Revert").play()
		restore_position()

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion && self.button_pressed && cell.type != Cell.CellType.FoundationCell:
		move(event.relative)

	if event is InputEventMouseButton && event.double_click && cell.type != Cell.CellType.FoundationCell:
		double_clicked = true


func move(movement: Vector2) -> void:
	self.position += movement
	if child != null:
		child.move(movement)

func automove(end_position: Vector2) -> void:
	var start_position = self.global_position
	var distance = (end_position - start_position).length()
	var time_s: float = distance / automove_speed
	var progress: float = 0	
	while progress < 1:
		self.global_position = lerp(start_position,end_position, progress)
		progress += (1.0 / automove_fps) / time_s
		await get_tree().create_timer(1.0 / automove_fps).timeout
	self.global_position = end_position
	cell.automove_complete(self)



static func get_suit_color(_suit: Suit) -> SuitColor:
	if _suit == Suit.HEARTS || _suit == Suit.DIAMONDS:
		return SuitColor.RED
	else:
		return SuitColor.BLACK

func get_card_number() -> int:
	return ((rank-1) * 4) + suit


func get_cascade_size() -> int:
	if child != null:
		return child.get_cascade_size() + 1
	return 1

func is_legal_cascade() -> bool:
	if child == null:
		return true
	else:
		return child.is_legal_cascade() && self.rank == child.rank + 1 && Card.get_suit_color(self.suit) != Card.get_suit_color(child.suit)
