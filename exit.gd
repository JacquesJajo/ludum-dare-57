extends Node2D

@export var next_level_id: int

func _on_area_2d_body_entered(body):
	if body.has_method("exit"):
		body.exit(next_level_id)
