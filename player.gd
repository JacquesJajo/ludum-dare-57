extends CharacterBody2D

enum State {IDLE, MOVE, SUNK}

const STEP_SIZE: float = 32.0
const MAX_STEPS: int = 20
const SPEED: float = 150.0

signal player_sink

var steps: int

var score: int

var target_pos: Vector2
var state: State = State.IDLE

func _ready():
	steps = MAX_STEPS
	$GFX.material.set_shader_parameter("steps", steps)
	$GFX.material.set_shader_parameter("max_steps", MAX_STEPS)
	$UILayer/Control/Vignette.material.set_shader_parameter("steps", steps)
	$UILayer/Control/Vignette.material.set_shader_parameter("max_steps", MAX_STEPS)

func _process(delta):
	match state:
		State.IDLE:
			if Input.is_action_pressed("up"):
				_step(Vector2.UP)
			if Input.is_action_pressed("down"):
				_step(Vector2.DOWN)
			if Input.is_action_pressed("left"):
				_step(Vector2.LEFT)
			if Input.is_action_pressed("right"):
				_step(Vector2.RIGHT)
		State.MOVE:
			self.position = self.position.move_toward(target_pos, SPEED * delta)
			if self.position == target_pos:
				state = State.IDLE
		State.SUNK:
			pass

func _step(dir):
	$GFX.look_at(self.global_position + STEP_SIZE * dir.rotated(PI/2.0))
	$TileRayCast.target_position = STEP_SIZE * dir
	$TileRayCast.force_raycast_update()
	if $TileRayCast.is_colliding():
		var tile = $TileRayCast.get_collider().get_parent()
		if tile.has_method("bump"):
			tile.bump()
		return
		
	target_pos = self.position + STEP_SIZE * dir
	state = State.MOVE
	steps -= 1
	if steps <= 0:
		steps = 0
		state = State.SUNK
		player_sink.emit()
	$GFX.material.set_shader_parameter("steps", steps)
	$UILayer/Control/Vignette.material.set_shader_parameter("steps", steps)

func lift():
	steps = MAX_STEPS
	$GFX.material.set_shader_parameter("steps", steps)
	$UILayer/Control/Vignette.material.set_shader_parameter("steps", steps)

func collect_treasure(amount: int):
	score += amount

func is_moving():
	return state == State.MOVE
func is_idle():
	return state == State.IDLE
