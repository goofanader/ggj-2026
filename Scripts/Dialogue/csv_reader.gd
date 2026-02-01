extends Node

func load_csv(path: String) -> dialog_resource:
	var resource = dialog_resource.new()
	
	var file := FileAccess.open(path, FileAccess.READ)
	
	file.get_csv_line()
	
	while not file.eof_reached():
		var row := file.get_csv_line()
		var j := dialogue_choices.new()
		
		var line := dialogue_lines.new()
		
		for i in range(row):
			j[i].text = row[i]
			j[i].damage = row[i+1]
			j[i].annoyance = row[i+2]
			
			resource.lines.append(j)
			
	return resource
