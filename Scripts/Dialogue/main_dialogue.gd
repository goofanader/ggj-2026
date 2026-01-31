extends Control

@onready var dialogue_list: VBoxContainer = $MarginContainer/ScrollContainer/VBoxContainer
@onready var scroll_container: ScrollContainer = $MarginContainer/ScrollContainer
@onready var npc_dialog_text := preload("res://Scenes/NPC Dialog Text.tscn")

#@onready var choice_list: VBoxContainer = $Choices

var DialogueScene := preload("res://Scenes/Dialog.tscn")
#var ChoiceButton := preload("res://Scenes/ChoiceButton.tscn")

func _ready():
	DialogueManager.line.connect(_on_line)

func _on_line(next):
	var texty = npc_dialog_text.instantiate()
	dialogue_list.add_child(texty)
	
	texty.set_text(next.text)
	
	await get_tree().process_frame
	scroll_container.scroll_vertical = scroll_container.get_v_scroll_bar().max_value
