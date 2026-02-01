extends Node

class_name csv_reader

static func load_csv(path: String) -> dialog_resource:
	var resource = dialog_resource.new()
	if(resource == null):
		print("didnt make resource")
		
	print("made resource")
	var file := FileAccess.open(path, FileAccess.READ)
	
	if (file == null):
		push_error("Failed to open CSV: " + path)
		return resource
	
	file.get_csv_line()
	
	while not file.eof_reached():
		var row := file.get_csv_line()
		
		var line := dialogue_lines.new()
		line.text = row[0]
		
		var i := 1
		while i + 2 < row.size():
			var choice := dialogue_choices.new()
			choice.text = row[i]
			choice.damage = int(row[i + 1])
			choice.annoyance = int(row[i + 2])
			
			print("Choice: ", choice.text, " Damage: ", choice.damage, " Annoyance: ", choice.annoyance)

			line.choices.append(choice)
			i += 3
		resource.lines.append(line) 
			
	print("successfully loaded")
	return resource
