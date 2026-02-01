extends Resource
class_name ChoiceData

@export var text: String
@export var player_damage: int = 0
@export var customer_damage: int = 0

func _init(text_:String="", player_damage_:int=0, customer_damage_:int=0) -> void:
	text = text_
	player_damage = player_damage_
	customer_damage = customer_damage_
