extends Node

var allow_save_game: bool

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("save_game"):
		save_game()


func save_game() -> void:
	print("SaveGameManager: Attempting to save...")
	
	var save_level_data_component: SaveLevelDataComponent = get_tree().get_first_node_in_group("save_level_data_component")
	
	if save_level_data_component != null:
		print("SaveGameManager: Component found! Saving now.")
		save_level_data_component.save_game()
	else:
		print("ERROR: SaveLevelDataComponent NOT found! Make sure the node exists and is in the group.")


func load_game() -> void:
	var save_level_data_component: SaveLevelDataComponent = get_tree().get_first_node_in_group("save_level_data_component")
	
	if save_level_data_component != null:
		save_level_data_component.load_game()
