@tool
extends Resource
class_name csv_reader

enum OutputMode {Replace,Append}

@export var data_resource: CustomerData
@export var output_mode: OutputMode = OutputMode.Replace

@export_file var question_in_file: String
@export_tool_button("Read Question File", "Callable") var read_question_data = read_question_data_fun

@export_file var farewell_in_file: String
@export_tool_button("Read Farewell File", "Callable") var read_farewell_data = read_farewell_data_fun

func read_question_data_fun() -> void:
	var questions: Array[QuestionData]
	var data: Array = csv_reader.load_csv(question_in_file)
	for r:int in range(1,data.size()):
		var row: Array = data[r]
		var question: QuestionData = QuestionData.new(row[0])
		var i: int = 1
		while i + 4 <= row.size():
			var choice: ChoiceData = ChoiceData.new(row[i],row[i+1],int(row[i+2]), int(row[i+3]))
			question.choices.append(choice)
			i+=4
		questions.append(question)
	if data_resource:
		if output_mode == OutputMode.Replace:
			data_resource.question_data = questions
		else:
			for question: QuestionData in questions: data_resource.question_data.append(question)
		print("Successfully wrote to resource")
	else:
		print("No Resource Found")

func read_farewell_data_fun() -> void:
	var responses: Dictionary[CustomerNode.Mood,Array] = {}
	var data: Array = csv_reader.load_csv(farewell_in_file)
	for r:int in range(1,data.size()):
		var row: Array = data[r]
		var mood:CustomerNode.Mood = (3-(int(row[1])-1)) as CustomerNode.Mood
		if not responses.has(mood): responses[mood] = []
		responses[mood].append(row[0])
	if data_resource:
		if output_mode == OutputMode.Replace:
			data_resource.farewell_data = responses
		else:
			for mood:CustomerNode.Mood in responses:
				if not data_resource.farewell_data.has(mood): data_resource.farewell_data[mood] = []
				for response:String in responses[mood]:
					data_resource.farewell_data[mood].append(response)
		print("Successfully wrote to resource")
	else:
		print("No Resource Found")



static func load_csv(path: String) -> Array:
	if not FileAccess.file_exists(path):
		push_error("Can't find CSV: " + path)
		return []
	var file := FileAccess.open(path, FileAccess.READ)
	if (file == null):
		push_error("Failed to open CSV: " + path)
		return []
	file.get_csv_line()
	var ans:Array = []
	while not file.eof_reached():
		var row := file.get_csv_line()
		var row_text: Array[String] = []
		for v:String in row: row_text.append(v)
		ans.append(row_text)		
	print("Successfully opened CSV")
	return ans
