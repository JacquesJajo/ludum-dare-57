extends Node2D

@export var level_id: int

signal restart_level(level: int)

func _on_player_sink():
	restart_level.emit(level_id)
