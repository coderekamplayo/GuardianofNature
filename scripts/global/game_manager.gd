extends Node

var game_menu_screen = preload("res://scenes/ui/game_menu_screen.tscn")

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("game_menu"):
		show_game_menu_screen()

# Called when "Start Game" (New Game) is clicked
func start_game() -> void:
	SceneManager.load_main_scene_container()
	SceneManager.load_level("Level1") # Start fresh at Level 1
	SaveGameManager.allow_save_game = true
	# REMOVED: SaveGameManager.load_game() -> We don't want to load old data for a new game!

# Called when "Load Game" is clicked (from your main menu usually)
func load_game() -> void:
	SceneManager.load_main_scene_container()
	# The SaveManager should handle placing the player and loading the correct level data
	await get_tree().process_frame
	await get_tree().process_frame
	
	SaveGameManager.load_game() 
	SaveGameManager.allow_save_game = true

func exit_game() -> void:
	get_tree().quit()

func show_game_menu_screen() -> void:
	# 1. Check if the menu is already open to prevent duplicates
	if get_tree().root.has_node("GameMenuScreen"):
		return
		
	# 2. Instantiate and add the menu
	var game_menu_screen_instance = game_menu_screen.instantiate()
	# Optional: Name it so we can find it later
	game_menu_screen_instance.name = "GameMenuScreen" 
	get_tree().root.add_child(game_menu_screen_instance)
	
	get_tree().paused = true
