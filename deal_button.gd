extends Button

@export var deal_menu: Control

func _on_pressed():
	deal_menu.show_deal_buttons()
