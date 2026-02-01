extends Node2D

signal mistake(type: String)

@export var settle: int = 2 #Initial drop
@export var fall: int = 75 #Fall speed
@export var follow_cursor: int = 150 #Speed you can move them

var stop: float
var held: bool = false
var hold_point: Vector2
var scanned: bool

var textures = [
	preload("res://Assets/Art/Items/Cyber_Circle_Mask.png"),
	preload("res://Assets/Art/Items/gold_cat.png"),
	preload("res://Assets/Art/Items/green_mask.png"),
	preload("res://Assets/Art/Items/Masquerade_Mask.png"),
	preload("res://Assets/Art/Items/Oni_Mask.png"),
	preload("res://Assets/Art/Items/skull.png"),
	preload("res://Assets/Art/Items/Scuba_Mask.png"),
	preload("res://Assets/Art/Items/Doll_Mask.png"),
	preload("res://Assets/Art/Items/Fish_Mask.png"),
	preload("res://Assets/Art/Items/Vendetta_Neon_Mask.png"),
	preload("res://Assets/Art/Items/Angel_Mask.png"),
	preload("res://Assets/Art/Items/Alien_Mask.png"),
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scanned = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if held:
		var mouse = get_viewport().get_mouse_position()
		var target_pos = mouse - hold_point
		if target_pos.y > stop:
			target_pos.y = stop
		if (target_pos-position).length() > 2:
			set_position(position + (target_pos - position).normalized() * follow_cursor * delta)
		
		#Let go if mouse is not held
		if not Input.is_mouse_button_pressed(MouseButton.MOUSE_BUTTON_LEFT):
			held = false
			$Drop.play()
			#TODO: Set new stop. Not important.
		
	elif position.y < stop:
		set_position(position + Vector2.DOWN * fall * delta)


func initialize(pos: Vector2) -> void:
	set_position(pos)
	stop = pos.y + settle
	$Sprite2D.texture = textures[randi()%textures.size()]


func _on_hitbox_input_event(viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT and event.pressed:
			held = true
			hold_point = viewport.get_mouse_position()-position
			$Pickup.play()
			viewport.set_input_as_handled()


func _on_hitbox_area_entered(_area: Area2D) -> void:
	if not scanned:
		scanned = true
	else:
		mistake.emit("scan")
