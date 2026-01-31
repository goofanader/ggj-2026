extends Node2D

@export var settle: int = 1
@export var fall: int = 2

var stop: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if position.y < stop:
		set_position(position + Vector2.DOWN * fall * delta)


func initialize(pos: Vector2) -> void:
	set_position(pos)
	stop = pos.y + settle
	
	#TODO: randomize item sprite
