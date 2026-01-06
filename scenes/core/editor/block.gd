extends VisualEventBS
class_name Block

## Oh, GOD, what the HELL is this???
## How did I have no idea how terrible this code is?
## TODO: Throw out this entire script and rewrite it from scratch.
## Why? Because I couldn't code a proper system for shit a year ago.
## That, and I probably wrote half of this while in class.


enum BLOQ_DIRECTIONS {
	UP = 0,
	DOWN = 1,
	LEFT = 2,
	RIGHT = 3,
	UP_LEFT = 4,
	UP_RIGHT = 5,
	DOWN_LEFT = 6,
	DOWN_RIGHT = 7,
	ANY = 8
}

enum BLOQ_COLORS {
	RED = 0,
	BLUE = 1
}

@export var selected : bool = false


@export var glossy : bool = false


# V3 JSON SETTINGS
@export var color : BLOQ_COLORS = BLOQ_COLORS.RED

@export var direction : BLOQ_DIRECTIONS = BLOQ_DIRECTIONS.DOWN
@export var angle_offset : int = 0
# END OPF V3 JSON SETTINGS

@export var rgb_color : Color

@export var custom_shader : bool = false
@export var bloq_multiplier : float = 0.45 # 0.28 MMA2 Style 0.4 CM Style 0.45 LUC Style
@export var arrow_multiplier : float = 12 # 0.405 MMA2 Style 1.3 CM Style 12 LUC Style
@export var arrow_white : float = 0.0625 # 0 MMA2 Style 0.125 CM Style 0.0625 LUC Style
@export var block_dissolve : float = 1:
	set(value):
		block_mesh.set_instance_shader_parameter("noise_interpolate", value)
		block_dissolve = value
		
@export var arrow_dissolve : float = 1:
	set(value):
		## TODO: Update Arrow Shader.
		arrow_mesh.material_override.set_shader_parameter("noise_interpolate", value)
		arrow_dissolve = value

@export var block_mesh : MeshInstance3D
@export var arrow_mesh : MeshInstance3D
@export var dot_mesh : MeshInstance3D

@export var error_logger : Node

@export var editor_node : LucidiumEditor

@export var angle_snap_block : Block
var hovered : bool = false

var color_note_resource : ColorNote

func update_color(new_color : Color, new_note_color := color, color_multiplier := bloq_multiplier):
	block_mesh.set_instance_shader_parameter("albedo", new_color)
	if custom_shader:
		## TODO: Update custom shader.
		block_mesh.material_override.set_shader_parameter("color_multiplier", bloq_multiplier)
	color = new_note_color

func update_arrow_color(albedo := rgb_color, multiplier := arrow_multiplier, white:= arrow_white):
	## TODO: Update Arrow shader.
	arrow_mesh.set_instance_shader_parameter("albedo", rgb_color) 
	arrow_mesh.set_instance_shader_parameter("color_multiplier", arrow_multiplier)
	arrow_mesh.set_instance_shader_parameter("white_blend", arrow_white)

func update_direction(new_direction : BLOQ_DIRECTIONS, new_angle_offset : int):
	## Why rely on calling a function in a child directly instead of just emitting a signal?
	## TODO: Write the damn signal.
	direction = new_direction
	angle_offset = new_angle_offset
	transform_component.update_rotation()

func update_position(new_x : int, new_y : int):
	## Why rely on calling a function in a child directly instead of just emitting a signal?
	## TODO: Write the damn signal.
	x = new_x
	y = new_y
	transform_component.update_position(true, true, false)

func update_selection(new_selected: bool):
	## TODO: Move this logic to a reusable component. Dumbass.
	if new_selected:
		block_mesh.material_overlay = load("res://materials/outline.tres")
	else:
		block_mesh.material_overlay = null
	selected = new_selected
	
func _ready() -> void:
	# Configure Material
	var bloq_material = load("res://materials/bloq/bloqShader.tres")
	var arrow_material = load("res://materials/bloq/arrowShader.tres")
	block_mesh.material_override = bloq_material
	arrow_mesh.material_override = arrow_material
	dot_mesh.material_override = arrow_material
	if custom_shader:
		## TODO: Move these to per instance uniform?
		## I'm not exactly sure what to do with this one.
		if glossy:
			block_mesh.material_override.set_shader_parameter("roughness", 0.29)
			block_mesh.material_override.set_shader_parameter("metallic", 0)
		else:
			block_mesh.material_override.set_shader_parameter("roughness", 1)
			block_mesh.material_override.set_shader_parameter("metallic", 1)
	
	if color == BLOQ_COLORS.RED:
		rgb_color = Color(0.784, 0.078, 0.078, 1.0)
	else:
		rgb_color = Color(0.157, 0.557, 0.824, 1.0)
	
	update_color(rgb_color)
	update_direction(direction, angle_offset)
	update_position(x, y)
	update_arrow_color()
	

func _input_event(camera: Camera3D, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1 && event.pressed == true && event.shift_pressed == true:
			error_logger.log_message("One small [25 MINUTES] for [CLICKING BLOQ], one giant leap for [LUCIDIUM MAPPER]")
			update_selection(!selected)
			

func _on_mouse_entered() -> void:
	hovered = true

func _on_mouse_exited() -> void:
	hovered = false

func _input(event: InputEvent) -> void:
	if hovered and Input.is_action_pressed("quick_edit_modifier") && !event.is_released():
		error_logger.log_message("Arrow Modifier Registered")
		if event.is_action("arrow_dot"):
			# TODO: Set Deg based off of prior direction
			update_direction(BLOQ_DIRECTIONS.ANY, 0)
		else:
			var arrow_vector = Input.get_vector("arrow_down", "arrow_up", "arrow_left", "arrow_right")
			var arrow_deg = rad_to_deg(atan2(arrow_vector.y, arrow_vector.x))
			if !arrow_deg > 0:
				arrow_deg = 180 + remap(abs(arrow_deg), 0, 180, 180, 0)
			error_logger.log_message(str(arrow_deg))
			match int(arrow_deg):
				0:
					update_direction(BLOQ_DIRECTIONS.UP, 0)
				45:
					update_direction(BLOQ_DIRECTIONS.UP_RIGHT, 0)
				90:
					update_direction(BLOQ_DIRECTIONS.RIGHT, 0)
				135:
					update_direction(BLOQ_DIRECTIONS.DOWN_RIGHT, 0)
				180:
					update_direction(BLOQ_DIRECTIONS.DOWN, 0)
				225:
					update_direction(BLOQ_DIRECTIONS.DOWN_LEFT, 0)
				270:
					update_direction(BLOQ_DIRECTIONS.LEFT, 0)
				315:
					update_direction(BLOQ_DIRECTIONS.UP_LEFT, 0)
				360:
					update_direction(BLOQ_DIRECTIONS.UP, 0)
