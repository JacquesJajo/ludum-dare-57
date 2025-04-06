extends Node2D

enum State {IDLE, MOVE}

const STEP_SIZE: float = 32.0
const SPEED: float = 150.0

@export var direction: Vector2

var state: State = State.IDLE
var target_pos: Vector2

var angular_velocity = 4.0*PI

func _process(delta):
	$GFX.rotate(angular_velocity * delta)
	match state:
		State.IDLE:
			$TileRayCast.target_position = STEP_SIZE * direction
			$TileRayCast.force_raycast_update()
			if $TileRayCast.is_colliding():
				direction = -direction
			else:
				state = State.MOVE
				target_pos = self.position + STEP_SIZE * direction
		State.MOVE:
			self.position = self.position.move_toward(target_pos, SPEED * delta)
			if self.position == target_pos:
				state = State.IDLE


func _on_area_2d_body_entered(body):
	if body.has_method("rebound"):
		body.rebound(-direction)
