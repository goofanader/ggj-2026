extends Control
class_name DialogBox

@export var dialog_text_left: PackedScene
@export var dialog_text_right: PackedScene
@export var list_node: Container
@export var scroll_node: ScrollContainer

enum Direction {Left,Right}

func add_text(text:String, direction:Direction, color:Color=Color.WHITE) -> void:
	var t: DialogText
	if direction==Direction.Left:
		t = dialog_text_left.instantiate() 
	else:
		t = dialog_text_right.instantiate()
	t.text = text
	t.color = color
	list_node.add_child(t)
	get_tree().create_timer(0.01).timeout.connect(scroll_down)

func add_break() -> void:
	var n: HSeparator = HSeparator.new()
	list_node.add_child(n)

func scroll_down() -> void:
	scroll_node.scroll_vertical = roundi(scroll_node.get_v_scroll_bar().max_value)

func clear_text() -> void:
	for n:Node in list_node.get_children(): n.queue_free()
