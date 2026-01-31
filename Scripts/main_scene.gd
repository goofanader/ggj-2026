extends Node2D
class_name MainNode

## -----------------------------------------------------------------------------
##             Data
## -----------------------------------------------------------------------------

@export_group("Game Data")
@export var customer_data: CustomerData
var items = []
var scan_number: int

## -----------------------------------------------------------------------------
##             Node Attachements
## -----------------------------------------------------------------------------

@export_group("Attachments")
@export var customer_spawn: Marker2D
@export var item_scene: PackedScene
@export var background_audio_node: BackgroundSoundPlayer

## -----------------------------------------------------------------------------
##             Input
## -----------------------------------------------------------------------------

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Quit"):
		get_tree().quit()
	elif event.is_action_pressed("Spawn New Customer"):
		new_customer()
	elif event.is_action_pressed("Clear Customers"):
		clear_customers()

## -----------------------------------------------------------------------------
##             Customer Methods
## -----------------------------------------------------------------------------

@export_group("Internal Variables")
@export var customer_nodes: Array[CustomerNode] = []

func new_customer() -> void:
	var customer_node:CustomerNode = customer_data.generate_new()
	add_customer(customer_node)

func add_customer(customer_node: CustomerNode) -> void:
	customer_nodes.append(customer_node)
	customer_node.leaving.connect(remove_customer)
	customer_node.drop_item.connect(drop_items)
	customer_node.position = customer_spawn.position
	add_child(customer_node)
	customer_node.enter()

func remove_customer(customer_node:CustomerNode) -> void:
	if customer_nodes.has(customer_node):
		customer_nodes.erase(customer_node)
	customer_node.leave()
	clear_items()
	
func clear_customers() -> void:
	if customer_nodes.size() > 0:
		for customer_node: CustomerNode in customer_nodes.duplicate():
			remove_customer(customer_node)

## -----------------------------------------------------------------------------
##             Item Methods
## -----------------------------------------------------------------------------

func drop_items() -> void:
	#Assuming max items is 3
	var n_items = randi_range(1,3)
	for i in range(n_items):
		var item = item_scene.instantiate()
		item.initialize($Fg/ItemDrops.get_child(i).position)
		$Fg.add_child(item)
		item.connect("mistake",_on_item_mistake)
		items.append(item)
	scan_number = 0


func _on_item_mistake(type: String) -> void:
	customer_nodes[0].damage(20)
	print("I am very angry")
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
			print("Bye Felicia")
			remove_customer(customer_nodes[0])
		
