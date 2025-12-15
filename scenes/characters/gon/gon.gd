extends Node2D

var ballon_scene = preload("res://dialogue/game_dialogue_balloon.tscn")

@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var interactable_label_component: Control = $InteractableLabelComponent

var in_range: bool

func _ready() -> void:
	interactable_component.interactable_activated.connect(on_interactable_activated)
	interactable_component.interactable_deactivated.connect(on_interactable_deactivated)
	interactable_label_component.hide()


func on_interactable_activated() -> void:
	interactable_label_component.show()
	in_range = true

func on_interactable_deactivated() -> void:
	interactable_label_component.hide()
	in_range = false

func _unhandled_input(event: InputEvent) -> void:
	if in_range: 
		if event.is_action_pressed("show_dialogue"):
			var ballon: BaseGameDialogueBalloon = ballon_scene.instantiate()
			get_tree().root.add_child(ballon)
			ballon.start(load("res://dialogue/conversations/gon.dialogue"), "start")
