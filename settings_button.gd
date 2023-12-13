class_name SettingsButton
extends TextureButton

@export var settings_popup: SettingsPopup

func _on_pressed():
	settings_popup.open()

