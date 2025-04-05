extends Node2D

const sea = preload("res://sea.tscn")
const TILE_SIZE: float = 32.0

@export var breakage: float

func _ready():
	breakage = 0.0

func _process(delta):
	$GFX.material.set_shader_parameter("breakage", breakage)
	
func bump():
	$BreakAnimation.play("break")

func recursive_bump(dir: Vector2):
	$AdjacentCast.target_position = dir * TILE_SIZE
	$AdjacentCast.force_raycast_update()
	if $AdjacentCast.is_colliding():
		var tile = $AdjacentCast.get_collider().get_parent()
		if tile.has_method("bump"):
			tile.bump()

func _on_break_animation_finished(anim_name):
	recursive_bump(Vector2.UP)
	recursive_bump(Vector2.DOWN)
	recursive_bump(Vector2.LEFT)
	recursive_bump(Vector2.RIGHT)
	
	var instance = sea.instantiate()
	instance.position = position
	get_parent().add_child(instance)
	self.queue_free()
