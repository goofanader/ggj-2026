extends Node

signal line(line: dialogue_lines)
signal choice(choice: dialogue_choices)

var dialogue: dialog_resource
var current: dialogue_lines

func _ready():
	print("DialogueManager ready")
	DialogueManager.dialogue = dialogue
	DialogueManager.start("res://scripts/Dialogue/dialogue.csv")
	
func start(csv_path: String) -> void:
	dialogue = csv_reader.load_csv(csv_path)
	print("Csv loaded")
	_play()

func _play() -> void:
	if dialogue == null or dialogue.lines.is_empty():
		push_error("No lines loaded")
		return
		
	current = dialogue.lines[randi() % dialogue.lines.size()]
	line.emit(current)
	
func choose(i: int) -> void:
	choice.emit(current.choices[i])
