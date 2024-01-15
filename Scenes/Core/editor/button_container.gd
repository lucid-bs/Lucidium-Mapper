extends HBoxContainer

@export var current_active_button : Button
@export var current_active_menu : Control

@export var button_pressed : bool = false

func _on_logger_pressed() -> void:
	if button_pressed:
		current_active_menu.visible = false 
		current_active_button.button_pressed = false
		button_pressed = false
		if current_active_button == $Logger:
			$"../../../../..".split_offset = 750
			$"../../../../..".dragger_visibility = $"../../../../..".DRAGGER_HIDDEN
			return
	$"../../../../..".dragger_visibility = $"../../../../..".DRAGGER_VISIBLE
	$"../../../../..".split_offset = 468
	current_active_menu = $"../../Logger"
	current_active_menu.visible = true
	current_active_button = $Logger
	button_pressed = true

func _ready() -> void:
	$"../../../../..".dragger_visibility = $"../../../../..".DRAGGER_HIDDEN
