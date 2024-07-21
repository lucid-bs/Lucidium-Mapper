extends VisualEventBS
class_name Bomb



@export var selected : bool = false

@export var error_logger : Node

@export var editor_node : LucidiumEditor

var hovered : bool = false

var bomb_note_resource : BombNote

func update_position(new_x : int, new_y : int):
	x = new_x
	y = new_y
	transform_component.update_position(true, true, false)

func update_selection(new_selected: bool):
	if new_selected:
		$MeshInstance3D.material_overlay = load("res://materials/outline.tres").duplicate()
	else:
		$MeshInstance3D.material_overlay = null
	selected = new_selected
	
func _ready() -> void:
	
	update_position(x, y)
	
	

func _input_event(camera: Camera3D, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1 && event.pressed == true && event.shift_pressed == true:
			error_logger.log_message("One small [25 MINUTES] for [CLICKING BLOQ], one giant leap for [LUCIDIUM MAPPER]")
			update_selection(!selected)
			

func _on_mouse_entered() -> void:
	hovered = true

func _on_mouse_exited() -> void:
	hovered = false
