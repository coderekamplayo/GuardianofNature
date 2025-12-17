class_name GameTimeDataResource
extends NodeDataResource

@export var time: float

func _save_data(_node: Node) -> void:
	# Only save the fundamental time value; day/minute are derived
	time = DayAndNightCycleManager.time
	print("DEBUG: Saving time = ", time)

func _load_data(_window: Window) -> void:
	print("DEBUG: Loading time = ", time)
	DayAndNightCycleManager.time = time
	# Force recalculation by resetting derived values
	DayAndNightCycleManager.current_day = -1
	DayAndNightCycleManager.current_minute = -1
	DayAndNightCycleManager.recalculate_time()
	# Emit signals to update listeners
	DayAndNightCycleManager.game_time.emit(DayAndNightCycleManager.time)
