extends VisualEventBS
class_name Block


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


@export var glossy : bool = true


# V3 JSON SETTINGS
@export var color : BLOQ_COLORS = BLOQ_COLORS.RED

@export var direction : BLOQ_DIRECTIONS = BLOQ_DIRECTIONS.DOWN
@export var angle_offset : int = 0
# END OPF V3 JSON SETTINGS

@export var rgb_color : Color
@export var bloq_multiplier : float = 0.28 # 0.28 MMA2 Style
@export var arrow_multiplier : float = 0.405 # 0.405 MMA2 Style
@export var arrow_white : float = 0 # 0 MMA2 Style

var hovered : bool = false

func update_color(new_color : Color, new_note_color := color, color_multiplier := bloq_multiplier):
	$MeshInstance3D.material_override.set_shader_parameter("albedo", new_color)
	$MeshInstance3D.material_override.set_shader_parameter("color_multiplier", bloq_multiplier)
	color = new_note_color

func update_arrow_color(albedo := rgb_color, multiplier := arrow_multiplier, white:= arrow_white):
	$MeshInstance3D/Arrow.material_override.set_shader_parameter("albedo", rgb_color) 
	$MeshInstance3D/Arrow.material_override.set_shader_parameter("color_multiplier", arrow_multiplier)
	$MeshInstance3D/Arrow.material_override.set_shader_parameter("white_blend", arrow_white)

func update_direction(new_direction : BLOQ_DIRECTIONS, new_angle_offset : int):
	if direction == BLOQ_DIRECTIONS.ANY:
		$MeshInstance3D/Dot.visible = true
		$MeshInstance3D/Arrow.visible = false
	else:
		$MeshInstance3D/Dot.visible = false
		$MeshInstance3D/Arrow.visible = true


	global_rotation.z = 0
	
	match new_direction:
		0:
			global_rotation.z = deg_to_rad(180.0)
		1:
			global_rotation.z = deg_to_rad(0.0)
		2:
			global_rotation.z = deg_to_rad(-90.0)
		3:
			global_rotation.z = deg_to_rad(90.0)
		4:
			global_rotation.z = deg_to_rad(225.0)
		5:
			global_rotation.z = deg_to_rad(135.0)
		6:
			global_rotation.z = deg_to_rad(-45.0)
		7:
			global_rotation.z = deg_to_rad(45.0)

	global_rotation.z -= deg_to_rad(new_angle_offset)
	direction = new_direction
	angle_offset = new_angle_offset

func update_position(new_x : int, new_y : int):
	position.x = -1.5 + new_x
	position.y = 0.5 + new_y
	x = new_x
	y = new_y

func update_selection(new_selected: bool):
	if new_selected:
		$MeshInstance3D.material_overlay = load("res://materials/outline.tres").duplicate()
	else:
		$MeshInstance3D.material_overlay = null
	selected = new_selected
	
func _ready() -> void:
	# Configure Material
	var bloq_material = load("res://materials/bloq/bloqShader.tres").duplicate()
	var arrow_material = load("res://materials/bloq/arrowShader.tres").duplicate()
	$MeshInstance3D.material_override = bloq_material
	$MeshInstance3D/Arrow.material_override = arrow_material
	$MeshInstance3D/Dot.material_override = arrow_material
	if glossy:
		$MeshInstance3D.material_override.set_shader_parameter("roughness", 0.29)
		$MeshInstance3D.material_override.set_shader_parameter("metallic", 0)
	else:
		$MeshInstance3D.material_override.set_shader_parameter("roughness", 1)
		$MeshInstance3D.material_override.set_shader_parameter("metallic", 1)
	
	if color == BLOQ_COLORS.RED:
		rgb_color = Color(0.8, 0.644, 0.432)
	else:
		rgb_color = Color(0.548, 0.613, 0.640)
	update_color(rgb_color)
	update_direction(direction, angle_offset)
	update_position(x, y)
	
	update_arrow_color()
	

func _input_event(camera: Camera3D, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1 && event.pressed == true && event.shift_pressed == true:
			%ErrorLogger.log_message("One small [25 MINUTES] for [CLICKING BLOQ], one giant leap for [LUCIDIUM MAPPER]")
			update_selection(!selected)
func _on_mouse_entered() -> void:
	hovered = true

func _on_mouse_exited() -> void:
	hovered = false

func _input(event: InputEvent) -> void:
	if hovered and Input.is_action_pressed("quick_edit_modifier") && !event.is_released():
		%ErrorLogger.log_message("Arrow Modifier Registered")
		if event.is_action("arrow_dot"):
			# TODO: Set Deg based off of prior direction
			update_direction(BLOQ_DIRECTIONS.ANY, 0)
		else:
			var arrow_vector = Input.get_vector("arrow_down", "arrow_up", "arrow_left", "arrow_right")
			var arrow_deg = rad_to_deg(atan2(arrow_vector.y, arrow_vector.x))
			if !arrow_deg > 0:
				arrow_deg = 180 + remap(abs(arrow_deg), 0, 180, 180, 0)
			%ErrorLogger.log_message(str(arrow_deg))
			match int(arrow_deg):
				0:
					update_direction(BLOQ_DIRECTIONS.UP, 0)
					%ErrorLogger.log_message("Up")
				45:
					update_direction(BLOQ_DIRECTIONS.UP_RIGHT, 0)
					%ErrorLogger.log_message("Up Right")
				90:
					update_direction(BLOQ_DIRECTIONS.RIGHT, 0)
					%ErrorLogger.log_message("Right")
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
