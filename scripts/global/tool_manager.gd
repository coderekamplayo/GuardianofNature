extends Node

# [FIX] 1. Store the enabled tools as Strings (e.g. "AxeWood", "Pickaxe")
var enabled_tools: Array[String] = []

var selected_tool: DataTypes.Tools = DataTypes.Tools.None

signal tool_selected(tool: DataTypes.Tools)
signal enable_tool(tool: DataTypes.Tools)

# --- SAVE SYSTEM SETUP ---
var save_data_resource: ToolDataResource

func _ready() -> void:
	# Register to the save system so save_data() is called
	add_to_group("save_data_component")
	save_data_resource = ToolDataResource.new()

func save_data() -> Resource:
	save_data_resource._save_data(self)
	return save_data_resource

# --- TOOL LOGIC ---

func select_tool(tool: DataTypes.Tools) -> void:
	tool_selected.emit(tool)
	selected_tool = tool 

func enable_tool_button(tool: DataTypes.Tools) -> void:
	# [FIX] 2. When collecting a tool, convert to String and save to memory
	var tool_name = DataTypes.Tools.find_key(tool)
	
	if not enabled_tools.has(tool_name):
		enabled_tools.append(tool_name)
		
	enable_tool.emit(tool)

# --- HELPER FUNCTIONS FOR SAVE/LOAD ---

func get_enabled_tools() -> Array[String]:
	return enabled_tools

func set_enabled_tools(loaded_tools: Array[String]) -> void:
	enabled_tools = loaded_tools
	
	# [FIX] 3. Re-enable all tools found in the save file
	for tool_name in enabled_tools:
		# Convert String back to Enum Value (e.g. "AxeWood" -> 1)
		if tool_name in DataTypes.Tools:
			var tool_value = DataTypes.Tools[tool_name]
			enable_tool.emit(tool_value)
