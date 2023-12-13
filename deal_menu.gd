extends Control


@onready var board = $/root/Game/Board
@onready var deal_buttons = $DealButtons
@onready var deal_number_popup = $DealNumberPopup

func _ready():
	deal_buttons.visible = false
	deal_number_popup.visible = false

func toggle_deal_buttons():
	deal_buttons.visible = !deal_buttons.visible

func challenge_deal():
	Deal.challenge_deal(board)
	deal_buttons.visible = false

func random_deal():
	Deal.random_deal(board)
	deal_buttons.visible = false

func custom_deal(deal_nbr: String):
	Deal.custom_deal(board, deal_nbr as int)
	deal_number_popup.visible = false
	deal_buttons.visible = false

func redeal():
	Deal.redeal(board)
	deal_buttons.visible = false

func open_deal_number_popup():
	deal_buttons.visible = false
	deal_number_popup.visible = true


func _on_deal_pressed():
	pass # Replace with function body.

