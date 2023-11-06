extends StaticBody3D

class_name Bloq


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
@export var beat : float = 0
@export var color : BLOQ_COLORS = BLOQ_COLORS.RED

@export_range(0, 3) var x = 0
@export_range(0, 2) var y = 0

@export var direction : BLOQ_DIRECTIONS = BLOQ_DIRECTIONS.DOWN
@export var angle_offset : int = 0
# END OPF V3 JSON SETTINGS


func update_color(new_color : BLOQ_COLORS):
	if color == BLOQ_COLORS.RED:
		$MeshInstance3D.material_override.set_shader_parameter("albedo", Color(1, 0, 0))
	else:
		$MeshInstance3D.material_override.set_shader_parameter("albedo", Color(0.19, 0.62, 1))
	color = new_color

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
	
	$MeshInstance3D.material_override = bloq_material
	if glossy:
		$MeshInstance3D.material_override.set_shader_parameter("roughness", 0.75)
		$MeshInstance3D.material_override.set_shader_parameter("retallic", 1)
	else:
		$MeshInstance3D.material_override.set_shader_parameter("roughness", 1)
		$MeshInstance3D.material_override.set_shader_parameter("retallic", 0)
	
	update_color(color)
	update_direction(direction, angle_offset)
	update_position(x, y)
	
	

func _input_event(camera: Camera3D, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1 && event.pressed == true && event.shift_pressed == true:
			%ErrorLogger.log_message("One small [25 MINUTES] for [CLICKING BLOQ], one giant leap for [LUCIDIUM MAPPER]")
			update_selection(!selected)
