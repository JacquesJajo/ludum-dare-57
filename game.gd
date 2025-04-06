extends Node2D

var level_scenes = [
	preload("res://level_1.tscn"),
	preload("res://level_2.tscn"),
	preload("res://level_3.tscn")
]

var current_level

var current_level_id

func _on_restart_level(level):
	current_level_id = level
	$RestartTimer.start()

func _on_next_level(level):
	current_level.queue_free()
	current_level_id = level
	current_level = level_scenes[current_level_id].instantiate()
	current_level.restart_level.connect(_on_restart_level)
	current_level.next_level.connect(_on_next_level)
	call_deferred("add_child", current_level)

func _on_restart_timer_timeout():
	$RestartTimer.stop()
	current_level.queue_free()
	current_level = level_scenes[current_level_id].instantiate()
	current_level.restart_level.connect(_on_restart_level)
	current_level.next_level.connect(_on_next_level)
	call_deferred("add_child", current_level)


func _on_title_play():
	$Title.queue_free()
	current_level_id = 0
	current_level = level_scenes[current_level_id].instantiate()
	current_level.restart_level.connect(_on_restart_level)
	current_level.next_level.connect(_on_next_level)
	call_deferred("add_child", current_level)
