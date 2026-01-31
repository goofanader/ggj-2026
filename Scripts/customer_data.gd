extends Resource
class_name CustomerData


@export var sprites: Array[SpriteFrames] = []

@export var starting_mood_range: Vector2i = Vector2i(20,80):
	set(value):
		starting_mood_range = Vector2i(min(value[0],value[1]),max(value[0],value[1]))
@export var mood_scale_range: Vector2 = Vector2(0.5,2.0):
	set(value):
		mood_scale_range = Vector2(min(value[0],value[1]),max(value[0],value[1]))

@export var items: Array[Resource] = []

@export var customer_scene: PackedScene


func generate_new() -> CustomerNode:
	var new_customer: CustomerNode = customer_scene.instantiate()
	new_customer.sprite_frames = sprites.pick_random()
	new_customer.item = items[randi_range(0,items.size()-1)]
	new_customer.mood_level = randi_range(starting_mood_range[0],starting_mood_range[1])
	new_customer.mood_scale = randf_range(mood_scale_range[0],mood_scale_range[1])
	new_customer.transition_in = CustomerNode.Transitions.values().pick_random()
	new_customer.transition_out = CustomerNode.Transitions.values().pick_random()
	return new_customer
