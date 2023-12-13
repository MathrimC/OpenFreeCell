class_name SettingsPopup
extends Control

@export var difficulty: OptionButton
@export var max_deal_nbr: LineEdit
@export var autocomplete: OptionButton 
@export var color_picker: ColorPickerButton

@export var background: TextureRect

var player_settings: PlayerSettings

func _ready():
	self.visible = false
	player_settings = PlayerProfile.get_player_profile().player_settings
	difficulty.selected = player_settings.difficulty
	max_deal_nbr.text = "%s" % player_settings.max_deal_nbr
	autocomplete.selected = player_settings.auto_complete
	color_picker.color = background.self_modulate

func open():
	self.visible = true

func close():
	self.visible = false

func on_difficulty_selected(_difficulty: int):
	player_settings.difficulty = _difficulty as PlayerSettings.Difficulty
	player_settings.player_settings_changed.emit()

func on_max_deal_nbr_changed(_max_deal_nbr: String):
	var nbr = _max_deal_nbr as int
	if nbr > 0:		
		player_settings.max_deal_nbr = _max_deal_nbr as int
		player_settings.player_settings_changed.emit()
	max_deal_nbr.text = "%s" % player_settings.max_deal_nbr

func on_autocomplete_selected(_auto_complete: int):
	player_settings.auto_complete = _auto_complete as PlayerSettings.Autocomplete
	player_settings.player_settings_changed.emit()

func on_background_color_selected(color: Color):
	player_settings.background_color = color
	background.self_modulate = color
	player_settings.player_settings_changed.emit()
