class_name PlayerProfile
extends Resource

@export var player_stats: PlayerStats
@export var player_settings: PlayerSettings

static var player_profile: PlayerProfile

func _init():
	player_stats = PlayerStats.new()
	player_settings = PlayerSettings.new()


static func get_player_profile() -> PlayerProfile:
	if player_profile == null:
		if ResourceLoader.exists("user://player_profile.tres"):
			player_profile = ResourceLoader.load("user://player_profile.tres") as PlayerProfile
		else: 
			player_profile = PlayerProfile.new()
		player_profile.player_stats.player_stats_changed.connect(player_profile.save_player_profile)	
		player_profile.player_settings.player_settings_changed.connect(player_profile.save_player_profile)

	return player_profile


func save_player_profile():
	ResourceSaver.save(self, "user://player_profile.tres")
