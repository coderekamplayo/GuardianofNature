extends PanelContainer

@onready var log_label: Label = $MarginContainer/VBoxContainer/Logs/LogLabel
@onready var stone_label: Label = $MarginContainer/VBoxContainer/Stone/StoneLabel
@onready var corn_label: Label = $MarginContainer/VBoxContainer/Corn/CornLabel
@onready var tomato_label: Label = $MarginContainer/VBoxContainer/Tomato/TomatoLabel
@onready var egg_label: Label = $MarginContainer/VBoxContainer/Egg/EggLabel
@onready var milk_label: Label = $MarginContainer/VBoxContainer/Milk/MilkLabel

func _ready() -> void:
	InventoryManager.inventory_changed.connect(on_inventory_changed)
	# Optional: Initialize with 0s on start
	on_inventory_changed()

func on_inventory_changed() -> void:
	var inventory: Dictionary = InventoryManager.inventory
	
	
	if inventory.has("log"):
		log_label.text = str(inventory["log"])
	else:
		log_label.text = "0"

	if inventory.has("stone"):
		stone_label.text = str(inventory["stone"])
	else:
		stone_label.text = "0"

	if inventory.has("corn"):
		corn_label.text = str(inventory["corn"])
	else:
		corn_label.text = "0"

	if inventory.has("tomato"):
		tomato_label.text = str(inventory["tomato"])
	else:
		tomato_label.text = "0"

	if inventory.has("egg"):
		egg_label.text = str(inventory["egg"])
	else:
		egg_label.text = "0"

	if inventory.has("milk"):
		milk_label.text = str(inventory["milk"])
	else:
		milk_label.text = "0"
