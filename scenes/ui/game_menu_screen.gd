extends CanvasLayer

@onready var save_game_button: Button = $MarginContainer/VBoxContainer/SaveGameButton

func _ready() -> void:
	# Keep your existing logic
	save_game_button.disabled = !SaveGameManager.allow_save_game
	save_game_button.focus_mode = Control.FOCUS_ALL if SaveGameManager.allow_save_game else Control.FOCUS_NONE 
	
	# [FIX] Check if a save file actually exists on disk
	# (We assume Level 1 for this check, or you can check generic 'save_game' if you have one)
	var save_path = "user://game_data/save_Level1_game_data.tres" 
	var has_save = FileAccess.file_exists(save_path)
	
	# Get the Load button (assuming it's named LoadGameButton in your scene)
	var load_button = $MarginContainer/VBoxContainer/LoadGameButton
	if load_button:
		load_button.disabled = not has_save

func _on_start_game_button_pressed() -> void:
	get_tree().paused = false 
	GameManager.start_game()
	queue_free()

func _on_save_game_button_pressed() -> void:
	SaveGameManager.save_game()

func _on_exit_game_button_pressed() -> void:
	GameManager.exit_game()

func _on_load_game_button_pressed() -> void:
	get_tree().paused = false
	
	# [FIX] 1. Tell the manager we want to load data once the level opens
	SaveGameManager.should_load_on_level_start = true
	
	# [FIX] 2. Actually open the level (same as Start Game)
	GameManager.start_game()
	queue_free()
