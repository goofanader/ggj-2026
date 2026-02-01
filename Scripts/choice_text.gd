extends PanelContainer
class_name ChoiceText

@export_multiline var text: String:
	set(value):
		text = value
		rich_text_node.text = text

@export var rich_text_node: RichTextLabel

@export var customer_response: String = ""
@export var player_damage: int = 0
@export var customer_damage: int = 0

@onready var box_button := $MarginContainer3/NinePatchRect
@onready var box_button_material := box_button.material as ShaderMaterial

var data: ChoiceData

func load_data(data_:ChoiceData) -> void:
	data = data_
	text = data.text
	customer_response = data.customer_response
	player_damage = data.player_damage
	customer_damage = data.customer_damage


func _ready() -> void:
	box_button.material = null

signal clicked(choice)

#func _gui_input(event: InputEvent) -> void:
	#if event is InputEventMouseButton:
		#if event.pressed:
			#self.accept_event()
			#picked()


func picked() -> void:
	print("Clicked Choice: %s"%text)
	clicked.emit(data)
	$Choose.play()


func _on_button_mouse_entered() -> void:
	box_button.material = box_button_material
	$Hover.play()

func _on_button_mouse_exited() -> void:
	box_button.material = null
