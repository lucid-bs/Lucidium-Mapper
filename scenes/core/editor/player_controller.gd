class_name PlayerController
extends Node
# Manages Keybinds, editor cursor stuff
# Manages Selection, creates EditEvents

signal player_scrolled(up: bool)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_RIGHT: # Only allows rotation if right click down
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if event.pressed else Input.MOUSE_MODE_VISIBLE)
			MOUSE_BUTTON_WHEEL_UP: # Increases max velocity
				$"../EventManager".scroll_map(true)
			MOUSE_BUTTON_WHEEL_DOWN: # Decereases max velocity
				$"../EventManager".scroll_map(false)
