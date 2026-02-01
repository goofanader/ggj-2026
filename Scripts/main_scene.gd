extends Node2D
class_name MainNode

## -----------------------------------------------------------------------------
##             Data
## -----------------------------------------------------------------------------

@export_group("Game Data")
@export var customer_data: CustomerData
var items = []
var scan_number: int
var customer_leaving_early_damage: float = 15.0
@export var customer_text_color: Color = Color(0.314, 0.475, 0.592, 1.0)
@export var player_text_color: Color = Color(0.302, 0.49, 0.357, 1.0)

## -----------------------------------------------------------------------------
##             Node Attachements
## -----------------------------------------------------------------------------

@export_group("Attachments")
@export var customer_spawn: Marker2D
@export var item_scene: PackedScene
@export var player: CharacterStats
@export var dialog_box: DialogBox
@export var choice_box: ChoiceBox


## -----------------------------------------------------------------------------
##             Input
## -----------------------------------------------------------------------------

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Quit"):
		get_tree().quit()
	
	## TODO: Remove these before export
	elif event.is_action_pressed("Spawn New Customer"):
		$GameScene/Customer/CustomerTimer.stop()
		new_customer()
	elif event.is_action_pressed("Clear Customers"):
		clear_customers()


## -----------------------------------------------------------------------------
##             Game Logic
## -----------------------------------------------------------------------------
func _ready() -> void:
	$MainMenu.visible = true
	dialog_box.clear_text()
	choice_box.clear_choices()
	choice_box.clicked.connect(player_reponse)
	player.game_over.connect(game_over)

func start_game() -> void:
	$GameScene/Customer/CustomerTimer.start()

func game_over() -> void:
	print("You bastards are lucky i need to make rent")

## -----------------------------------------------------------------------------
##             Customer Methods
## -----------------------------------------------------------------------------

@export_group("Internal Variables")
var customer_nodes: Array[CustomerNode] = []

func new_customer() -> void:
	var customer_node:CustomerNode = customer_data.generate_new()
	add_customer(customer_node)

func add_customer(customer_node: CustomerNode) -> void:
	customer_nodes.append(customer_node)
	customer_node.leaving.connect(remove_customer)
	customer_node.drop_item.connect(drop_items)
	customer_node.ask_question.connect(ask_question)
	customer_node.speak.connect(customer_speak)
	customer_node.position = customer_spawn.position
	add_child(customer_node)
	customer_node.enter()
	$GameScene/Customer/WaitTimer.start()

func remove_customer(customer_node:CustomerNode, mad:bool=false) -> void:
	choice_box.clear_choices(customer_node)
	customer_node.leave()
	if customer_nodes.has(customer_node):
		dialog_box.add_break()
		customer_nodes.erase(customer_node)
		if mad: player.damage(customer_leaving_early_damage)
	$GameScene/Customer/CustomerTimer.start(randf_range(3,4))
	$GameScene/Customer/WaitTimer.stop()
	clear_items()
	
func clear_customers() -> void:
	if customer_nodes.size() > 0:
		for customer_node: CustomerNode in customer_nodes.duplicate():
			remove_customer(customer_node)

## -----------------------------------------------------------------------------
##             Question and Dialog Methods
## -----------------------------------------------------------------------------

func ask_question(customer:CustomerNode, question:QuestionData) -> void:
	customer_speak(question.text)
	choice_box.add_choices(question.choices, customer)

func customer_speak(text:String) -> void:
	dialog_box.add_text(text,DialogBox.Direction.Left,customer_text_color)

func player_speak(text:String) -> void:
	dialog_box.add_text(text,DialogBox.Direction.Right,player_text_color)

func player_reponse(customer:CustomerNode, choice:ChoiceData) -> void:
	player_speak(choice.text)
	player.damage(choice.player_damage)
	customer_speak(choice.customer_response)
	customer.damage(choice.customer_damage)


## -----------------------------------------------------------------------------
##             Item Methods
## -----------------------------------------------------------------------------

func drop_items() -> void:
	#Assuming max items is 3
	var n_items = randi_range(1,3)
	for i in range(n_items):
		var item = item_scene.instantiate()
		item.initialize($GameScene/Fg/ItemDrops.get_child(i).position)
		$GameScene/Fg.add_child(item)
		item.connect("mistake",_on_item_mistake)
		items.append(item)
	scan_number = 0


func _on_item_mistake(type: String) -> void:
	customer_nodes[0].damage(20)
	if type == "scan":
		print("You scanned that item twice")

func clear_items() -> void:
	for item in items:
		item.disconnect("mistake",_on_item_mistake)
		item.queue_free()
	items = []

## -----------------------------------------------------------------------------
##             Signal Methods
## -----------------------------------------------------------------------------

func _on_register_scan() -> void:
	scan_number += 1


func _on_register_checkout() -> void:
	print(customer_nodes)
	if customer_nodes.size() > 0 and items.size() > 0:
		if scan_number < items.size():
			customer_nodes[0].damage(30)
			print("What the heck you didn't scan all my stuff")
		else:
			remove_customer(customer_nodes[0])
		


func _on_customer_timer_timeout() -> void:
	new_customer()


func _on_wait_timer_timeout() -> void:
	customer_nodes[0].damage(1)
	#print("Time Passes")


func _on_start_button_pressed() -> void:
	$MainMenu.visible = false
	start_game()


func _on_credits_button_pressed() -> void:
	$Credits.visible = true

func _on_credits_back_button_pressed() -> void:
	$Credits.visible = false

func _on_options_back_button_pressed() -> void:
	$Options.visible = false

func _on_options_button_pressed() -> void:
	$Options.visible = true
