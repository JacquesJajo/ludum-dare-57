extends Node2D

@export var level_id: int

signal restart_level(level: int)
signal next_level(level: int)

func _on_player_sink():
	restart_level.emit(level_id)


func _on_player_exit(next_level_id):
	next_level.emit(next_level_id)
