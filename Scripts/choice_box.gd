extends Control
class_name ChoiceBox

@export var choice_text_scene: PackedScene
@export var list_node: Container

var last_customer: CustomerNode

signal clicked(customer_target, choice)

func add_choices(choices:Array[ChoiceData], customer:CustomerNode) -> void:
	clear_choices()
	last_customer = customer
	visible = true
	for choice:ChoiceData in choices:
		var t: ChoiceText = choice_text_scene.instantiate()
		t.load_data(choice)
		t.clicked.connect(clicked_choice)
		list_node.add_child(t)

func clicked_choice(choice: ChoiceData) -> void:
	clear_choices()
	clicked.emit(last_customer, choice)

func clear_choices(customer:CustomerNode=null) -> void:
	if customer==null or customer==last_customer:
		visible = false
		for n:Node in list_node.get_children(): n.queue_free()
