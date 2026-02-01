extends Resource
class_name QuestionData

@export var text: String
@export var choices: Array[ChoiceData]

func _init(text_:String="", choices_:Array[ChoiceData]=[]) -> void:
	text = text_
	choices = choices_
