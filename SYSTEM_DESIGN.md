# Guardian of Nature - System Design Document

This document provides a high-level overview of the technical architecture for the "Guardian of Nature" project. Its purpose is to define the responsibilities of each major system and how they will interact.

---

### 1. Core Systems Overview

The project is built on a modular architecture to ensure that systems are decoupled and easy to maintain.

#### **A. Player System (`actors/player/`)**

*   **Responsibility:** To manage all aspects of the player character, including input, movement, physics, and animations.
*   **Key Components:**
    *   `player.tscn` (`CharacterBody2D`): The main scene for the player, containing the physics body and collision shapes.
    *   `player.gd`: The core script that handles input processing, velocity calculations, and state management (idle, walk, run).
    *   `AnimatedSprite2D`: Manages the visual representation and animation playback.

#### **B. World System (`world/`)**

*   **Responsibility:** To manage the game level, including the environment layout, collision, and visual layers.
*   **Key Components:**
    *   `valley.tscn`: The main level scene.
    *   `TileMap`: The node responsible for rendering the grid-based world. It is configured with multiple layers to handle draw order and physics.
    *   `sunnyside_world.tres` (`TileSet`): The resource that defines the rules for every tile, including their texture, physics collision shapes, and terrain properties.

#### **C. Global Manager Systems (`autoload/`)**

*   **Responsibility:** To manage game-wide state and logic that needs to be accessible from any other system. These are implemented as Godot Autoloads (Singletons).
*   **Key Components:**
    *   `InventoryManager.gd`: Will be responsible for tracking all player-owned items. It will contain functions to add, remove, and check for items.
    *   `QuestManager.gd`: Will track the state of all quests.

---

### 2. Data Flow & Communication Strategy

To prevent rigid, hard-to-maintain code, systems will be decoupled and communicate primarily through **Godot's built-in Signal System**.

*   **Example:** When a crop is harvested, the `crop.gd` script will not directly call a function in the `InventoryManager`. Instead, it will emit a `crop_harvested` signal. The `InventoryManager` will listen for this signal and update its own state accordingly.
*   **Benefit:** This approach allows us to develop, test, and modify each system in isolation without breaking others.