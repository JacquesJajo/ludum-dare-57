extends CharacterBody2D

const STEP_SIZE: float = 32.0
const MAX_STEPS: int = 100

var steps: int

func _ready():
	steps = MAX_STEPS
	$GFX.material.set_shader_parameter("steps", steps)

func _process(delta):
	if Input.is_action_just_pressed("up"):
		_step(Vector2.UP)
	if Input.is_action_just_pressed("down"):
		_step(Vector2.DOWN)
	if Input.is_action_just_pressed("left"):
		_step(Vector2.LEFT)
	if Input.is_action_just_pressed("right"):
		_step(Vector2.RIGHT)

func _step(dir):
	$TileRayCast.target_position = STEP_SIZE * dir
	$TileRayCast.force_raycast_update()
	if $TileRayCast.is_colliding():
		return
		
	self.position += STEP_SIZE * dir
	steps -= 1
	if steps <= 0:
		steps = 0
	print(steps)
	$GFX.material.set_shader_parameter("steps", steps)

func lift():
	steps = MAX_STEPS
	$GFX.material.set_shader_parameter("steps", steps)
