extends Node

signal give_crop_seeds
signal feed_the_animals

# [NEW] Function to save the rating directly to a file
func action_save_rating(rating_value: String) -> void:
	print("Player rated the game: ", rating_value)
	
	# Open a file in the user data folder to write the result
	var file = FileAccess.open("user://player_feedback.txt", FileAccess.WRITE)
	if file:
		file.store_string("Rating: " + rating_value)
		file.close()
		print("Rating saved successfully to user://player_feedback.txt")
	else:
		print("Error saving rating.")

func action_give_crop_seeds() -> void:
	give_crop_seeds.emit()

func action_feed_animals() -> void:
	feed_the_animals.emit()

func action_give_axe_tool() -> void:
	ToolManager.enable_tool.emit(DataTypes.Tools.AxeWood)
