class_name DealPopup
extends Control

@export var deal_buttons: Container
@onready var board = $/root/Game/Board
@onready var deal_number_popup = $DealNumberPopup

func _ready():
	self.hide()
	deal_buttons.hide()
	deal_number_popup.hide()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.is_pressed():
		self.hide()

func show_deal_buttons() -> void:
	self.show()
	deal_buttons.show()
	deal_number_popup.hide()

func challenge_deal():
	Deal.challenge_deal(board)
	self.hide()

func daily_deal():
	Deal.daily_deal(board)
	self.hide()

func random_deal():
	Deal.random_deal(board)
	self.hide()

func custom_deal(deal_nbr: String):
	Deal.custom_deal(board, deal_nbr as int)
	deal_number_popup.hide()
	deal_buttons.hide()
	self.hide()

func redeal():
	Deal.redeal(board)
	self.hide()

func open_deal_number_popup():
	deal_buttons.hide()
	deal_number_popup.show()
