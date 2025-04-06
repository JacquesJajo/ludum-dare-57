extends Node2D


func _on_area_2d_body_entered(body):
	if body.has_method("collect_treasure"):
		body.collect_treasure(20, true)
		self.queue_free()
