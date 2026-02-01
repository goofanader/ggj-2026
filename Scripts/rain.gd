extends Path2D

@export var drop: PackedScene

func _on_timer_timeout() -> void:
	var new_drop = drop.instantiate()
	var drop_location = $PathFollow2D
	drop_location.progress_ratio = randf()
	new_drop.position = drop_location.position
	add_child(new_drop)
