extends Node2D

const SPEED: int = 800

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if position.y > 170:
		queue_free()
	else:
		position += Vector2.DOWN * SPEED * delta
