class_name SettingsButton
extends Button

@export var settings_popup: SettingsPopup

func _on_pressed():
	settings_popup.open()
