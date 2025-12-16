class_name TimeSaveDataComponent
extends Node

@onready var save_data_resource: GameTimeDataResource = GameTimeDataResource.new()

func _ready() -> void:
	add_to_group("save_data_component")

func save_data() -> Resource:
	save_data_resource._save_data(get_parent())
	return save_data_resource
