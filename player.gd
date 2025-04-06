extends CharacterBody2D

enum State {IDLE, MOVE, SUNK, REBOUND}

const STEP_SIZE: float = 32.0
const MAX_STEPS: int = 20
const SPEED: float = 150.0
const MAX_REBOUND_STEPS: int = 4

signal player_sink
signal player_exit(next_level_id: int)

@export var target_score: int

var steps: int

var score: int

var target_pos: Vector2
var state: State = State.IDLE

var last_step_dir: Vector2

var rebound_direction: Vector2
var rebound_steps: int
var rebounding: bool = false

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
				if rebounding:
					state = State.REBOUND
				else:
					state = State.IDLE
				if steps <= 0:
					steps = 0
					state = State.SUNK
					$Sink.play()
					$UILayer/Control/Sunk/MoveInFrame.play("Sunk")
					player_sink.emit()
		State.SUNK:
			pass
		State.REBOUND:
			var stepped = _step(rebound_direction)
			rebound_steps -= 1
			if !stepped or rebound_steps <= 0:
				state = State.IDLE
				rebounding = false

func _step(dir):
	last_step_dir = dir
	$GFX.look_at(self.global_position + STEP_SIZE * dir.rotated(PI/2.0))
	$TileRayCast.target_position = STEP_SIZE * dir
	$TileRayCast.force_raycast_update()
	if $TileRayCast.is_colliding():
		var tile = $TileRayCast.get_collider().get_parent()
		if tile.has_method("bump"):
			tile.bump()
		return false
		
	target_pos = self.position + STEP_SIZE * dir
	state = State.MOVE
	steps -= 1
	$GFX.material.set_shader_parameter("steps", steps)
	$UILayer/Control/Vignette.material.set_shader_parameter("steps", steps)
	
	if $UILayer/Control/CollectGold.visible:
		$UILayer/Control/CollectGold.hide()
	
	return true

func lift():
	steps = MAX_STEPS
	$GFX.material.set_shader_parameter("steps", steps)
	$UILayer/Control/Vignette.material.set_shader_parameter("steps", steps)

func collect_treasure(amount: int, big):
	score += amount
	if big:
		$PickupBig.play()
	else:
		$PickupSmall.play()
	$UILayer/Control/Score.text = "Gold: " + str(score)

func rebound(direction):
	if is_sunk():
		return
	if is_moving():
		self.position = target_pos
	state = State.REBOUND
	if direction == Vector2.ZERO:
		rebound_direction = last_step_dir
	else:
		rebound_direction = direction
	rebound_steps = MAX_REBOUND_STEPS
	rebounding = true
	$Whirlpool.play()

func exit(next_level_id):
	if score >= target_score:
		player_exit.emit(next_level_id)
	else:
		$UILayer/Control/CollectGold.show()

func is_moving():
	return state == State.MOVE
func is_idle():
	return state == State.IDLE
func is_sunk():
	return state == State.SUNK


func _on_background_waves_finished():
	$BackgroundWaves.play()
	if randi() % 100 > 50:
		$Seagull.play()
