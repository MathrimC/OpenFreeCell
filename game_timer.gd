class_name GameTimer
extends Node

var game_time_ms: int
var last_update_ms: int
var running: bool
var paused: bool

func start_timer():
	game_time_ms = 0
	last_update_ms = Time.get_ticks_msec()
	running = true
	paused = false
	update_time()

func stop_timer():
	running = false

func update_time():
	while running:
		var current_update_ms = Time.get_ticks_msec()
		if !paused:
			game_time_ms += 200
			last_update_ms = current_update_ms
		await get_tree().create_timer(0.2).timeout

func on_focus():
	last_update_ms = Time.get_ticks_msec()

func _notification(what):
	match what:
		MainLoop.NOTIFICATION_APPLICATION_FOCUS_IN:
			last_update_ms = Time.get_ticks_msec()
			paused = false
		MainLoop.NOTIFICATION_APPLICATION_FOCUS_OUT:
			paused = true
	
