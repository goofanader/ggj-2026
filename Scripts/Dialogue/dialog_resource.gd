@tool
extends Resource

class_name dialog_resource

@export var lines: Array[dialogue_lines] = []

@export_file("dialogue.csv") var csv_path: String:
	set(value):
		csv_path = value
		_import_csv()
		
func _import_csv() -> void:
	lines = csv_reader.load_csv(csv_path).lines
