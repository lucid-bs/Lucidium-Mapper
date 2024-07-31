@tool
class_name MessageBoardPanel
extends Panel

@export_multiline var message : String:
	set(value):
		message = value
		if is_ready:
			$ScrollContainer/VBoxContainer/Label.text = value

@export var sticky_stylebox : StyleBox

@export var sticky : bool:
	set(value):
		if value:
			add_theme_stylebox_override("panel", sticky_stylebox)
		else:
			remove_theme_stylebox_override("panel")
		sticky = value
		
var is_ready := false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	custom_minimum_size = $ScrollContainer/VBoxContainer/Label.size
	update_minimum_size()
	is_ready = true
	$ScrollContainer/VBoxContainer/Label.text = message
	


func _on_label_resized() -> void:
	custom_minimum_size = $ScrollContainer/VBoxContainer/Label.size + Vector2(0, 16)
	
	update_minimum_size()
