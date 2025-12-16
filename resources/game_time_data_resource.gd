class_name GameTimeDataResource
extends NodeDataResource

@export var time: float
@export var current_day: int
@export var current_minute: int

func _save_data(_node: Node) -> void:
	# We interpret 'node' as the DayAndNightCycleManager (even if it's not Node2D, we access the singleton directly or cast safely)
	# Actually, since we control the component, we know what we are saving.
	time = DayAndNightCycleManager.time
	current_day = DayAndNightCycleManager.current_day
	current_minute = DayAndNightCycleManager.current_minute

func _load_data(_window: Window) -> void:
	DayAndNightCycleManager.time = time
	DayAndNightCycleManager.current_day = current_day
	DayAndNightCycleManager.current_minute = current_minute
	DayAndNightCycleManager.recalculate_time()
