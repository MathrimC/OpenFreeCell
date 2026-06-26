extends Button

@export var deal_popup: DealPopup

func _on_pressed():
	deal_popup.show_deal_buttons()
