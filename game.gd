extends Node2D

var level_scenes = [
	preload("res://level_1.tscn")
]

@onready
var current_level = $Level1

var current_level_id

func _on_restart_level(level):
	current_level_id = level
	$RestartTimer.start()


func _on_restart_timer_timeout():
	$RestartTimer.stop()
	current_level.queue_free()
	current_level = level_scenes[current_level_id].instantiate()
	current_level.restart_level.connect(_on_restart_level)
	call_deferred("add_child", current_level)
