extends Resource
class_name ChoiceData

@export var text: String
@export var customer_response:String
@export var player_damage: int = 0
@export var customer_damage: int = 0

func _init(choice_text:String="", customer_response_:String="", player_damage_:int=0, customer_damage_:int=0) -> void:
	text = choice_text
	customer_response = customer_response_
	player_damage = player_damage_
	customer_damage = customer_damage_
