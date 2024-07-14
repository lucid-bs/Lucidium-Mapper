extends HBoxContainer

@export var current_active_button : Button
@export var current_active_menu : Control

@export var button_pressed : bool = false

var past_size : Vector2

func _on_logger_pressed() -> void:
	if button_pressed:
		current_active_menu.visible = false 
		current_active_button.button_pressed = false
		button_pressed = false
		if current_active_button == $Logger:
			$"../../../../..".split_offset = get_tree().get_root().size.y
			$"../../../../..".dragger_visibility = $"../../../../..".DRAGGER_HIDDEN
			return
	else:
		$"../../../../..".dragger_visibility = $"../../../../..".DRAGGER_VISIBLE
		$"../../../../..".split_offset = get_tree().get_root().size.y * 0.65
		current_active_menu = $"../../Logger"
		current_active_menu.visible = true
		current_active_button = $Logger
		button_pressed = true

func _ready() -> void:
	$"../../../../..".dragger_visibility = $"../../../../..".DRAGGER_HIDDEN
	get_tree().get_root().size_changed.connect(adjust_resized)
	past_size = get_tree().get_root().size
	

func adjust_resized():
	if !button_pressed:
		$"../../../../..".split_offset = get_tree().get_root().size.y
	else:
		$"../../../../..".split_offset = $"../../../../..".split_offset / past_size.y * get_tree().get_root().size.y
	
	past_size = get_tree().get_root().size
	
	
		
