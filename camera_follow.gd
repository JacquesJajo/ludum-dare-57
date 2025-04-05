extends Camera2D

const SPEED: float = 5.0

@export var Player: Node2D

func _process(delta):
	self.position = lerp(self.position, Player.position, SPEED * delta)
