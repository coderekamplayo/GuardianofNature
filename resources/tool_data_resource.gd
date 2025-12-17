class_name ToolDataResource
extends NodeDataResource

@export var collected_tools: Array[String] = []

func _save_data(node: Node) -> void:
	# We get the list from ToolManager (passed as 'node')
	if node.has_method("get_enabled_tools"):
		collected_tools = node.get_enabled_tools()

func _load_data(_window: Window) -> void:
	# Send the saved list back to the autoload
	ToolManager.set_enabled_tools(collected_tools)
