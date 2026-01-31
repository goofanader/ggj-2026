extends Node2D

@export var settle: int = 2 #Initial drop
@export var fall: int = 75 #Fall speed
@export var follow_cursor: int = 150 #Speed you can move them

var stop: float
var held: bool = false
var hold_point: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if held:
		var mouse = get_viewport().get_mouse_position()
		var target_pos = mouse - hold_point
		if target_pos.y > stop:
			target_pos.y = stop
		if (target_pos-position).length() > 2:
			set_position(position + (target_pos - position).normalized() * follow_cursor * delta)
	elif position.y < stop:
		set_position(position + Vector2.DOWN * fall * delta)


func initialize(pos: Vector2) -> void:
	set_position(pos)
	stop = pos.y + settle
	
	#TODO: randomize item sprite


func _on_color_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			held = true
			hold_point = get_viewport().get_mouse_position()-position
		else:
			held = false
			#TODO: Set new stop. Not important.
