class_name Player
extends CharacterBody2D

@onready var hit_component: HitComponent = $HitComponent

@export var current_tool: DataTypes.Tools = DataTypes.Tools.None

var player_direction: Vector2

func _ready() -> void:
	# [FIX] 1. Register the player to the save group so the manager finds it
	add_to_group("save_data_component")
	
	ToolManager.tool_selected.connect(on_tool_selected)

func on_tool_selected(tool: DataTypes.Tools) -> void:
	current_tool = tool
	hit_component.current_tool = tool

# [FIX] 2. Define the function that the SaveLevelDataComponent calls
func save_data() -> Resource:
	# Create a new generic resource to hold our data
	var resource = NodeDataResource.new()
	
	# Fill it with the player's position, animation, and blend_position
	# (This uses the logic we added to NodeDataResource in the previous step)
	resource._save_data(self)
	
	return resource
