class_name PlayerController
extends Node
# Manages Keybinds, editor cursor stuff
# Manages Selection, creates EditEvents

signal player_scrolled(up: bool)

@export var event_manager : EventManager

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_WHEEL_UP:
				event_manager.scroll_map(true)
			MOUSE_BUTTON_WHEEL_DOWN:
				event_manager.scroll_map(false)
