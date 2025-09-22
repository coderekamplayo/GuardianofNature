# This makes "NodeStateMachine" a custom class name that can be used as a type hint
# and added as a node type directly in the Godot editor.
class_name NodeStateMachine
# This script inherits from the base Node class.
extends Node

## --- EXPORTED VARIABLES ---
# This line creates a variable that will appear in the Godot Inspector.
# It allows you to drag and drop a NodeState from the scene tree to set the
# state machine's starting state.
@export var initial_node_state : NodeState

## --- MEMBER VARIABLES ---
# A Dictionary to hold all the available states.
# The keys will be the state names (in lowercase), and the values will be the actual state nodes.
var node_states : Dictionary = {}
# A variable to hold a reference to the currently active state node.
var current_node_state : NodeState
# A variable to store the name of the current state as a string for easy access/debugging.
var current_node_state_name : String
var parent_node_name: String


# The _ready function is called once when the node and all its children enter the scene tree.
# This is where we will set up the state machine.
func _ready() -> void:
	parent_node_name = get_parent().name
	# Loop through all the nodes that are direct children of this state machine node.
	for child in get_children():
		# Check if the child is a "NodeState". This is how the machine discovers all its possible states.
		if child is NodeState:
			# Add the state to our dictionary. We use the node's name (converted to lowercase) as the key
			# for easy, case-insensitive lookups later.
			node_states[child.name.to_lower()] = child
			
			# This is a crucial step for communication. It assumes each NodeState has a signal called "transition".
			# It connects this signal to the "transition_to" function of this state machine.
			# So, when a state wants to change, it just needs to emit its "transition" signal.
			child.transition.connect(transition_to)
	
	# After discovering all states, check if an initial state has been assigned from the Inspector.
	if initial_node_state:
		# Call the "_on_enter" function of the initial state to run its setup logic.
		initial_node_state._on_enter()
		# Set the machine's current state to the initial one.
		current_node_state = initial_node_state
		current_node_state_name = current_node_state.name.to_lower()


# The _process function is called on every rendered frame.
func _process(delta : float) -> void:
	# Check if there is a valid current state.
	if current_node_state:
		# If there is, delegate the frame-processing logic to the active state.
		# This allows each state to have its own unique behavior every frame.
		current_node_state._on_process(delta)


# The _physics_process function is called on every physics update frame.
# This is best for any logic involving physics, such as movement.
func _physics_process(delta: float) -> void:
	# Check if there is a valid current state.
	if current_node_state:
		# Delegate physics-related logic to the active state.
		current_node_state._on_physics_process(delta)
		
		# This calls a function on the state, likely to check if any conditions
		# have been met to transition to another state.
		current_node_state._on_next_transitions()
		print(parent_node_name, " Current State: ", current_node_state_name)


# This function handles the actual process of changing from one state to another.
# It is called when a state emits the "transition" signal.
func transition_to(node_state_name : String) -> void:
	# First, check if we are already in the state we are trying to transition to. If so, do nothing.
	if node_state_name.to_lower() == current_node_state.name.to_lower():
		return
	
	# Look up the new state in our dictionary using the provided name.
	var new_node_state = node_states.get(node_state_name.to_lower())
	
	# If no state with that name was found, abort the transition.
	if !new_node_state:
		return
	
	# If we have a current state, call its exit logic for any cleanup.
	if current_node_state:
		current_node_state._on_exit()
	
	# Call the enter logic for the new state to run its setup code.
	new_node_state._on_enter()
	
	# Update the state machine's current state to the new one.
	current_node_state = new_node_state
	# Update the name of the current state for debugging.
	current_node_state_name = current_node_state.name.to_lower()
