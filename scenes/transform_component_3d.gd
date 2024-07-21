extends Node
class_name TransformComponent3D
## Handles transforms for anything that needs to be visualized
##
## The TransformComponent can handle 3D transformations for any 3d object that has a "beat" parameter
## It handles regular Editor transformations and Game Emulation transformations (note jump, noodle, etc)
## If configured correctly, it can also handle lining up events with other events

enum PARENT_TYPE {
	NOTE = 0,
	BOMB = 1,
	WALL = 2,
	ARC = 3,
	CHAIN = 4,
	EDITOR_EVENT = 5,
}

@export var parent_type : PARENT_TYPE
@export var parent : VisualObject

func _ready() -> void:
	parent = get_parent()
	if get_parent() is Block:
		parent_type = PARENT_TYPE.NOTE
		
	parent.transform_component = self

func update_rotation():
	match parent_type:
		PARENT_TYPE.NOTE:
			if parent.direction == Block.BLOQ_DIRECTIONS.ANY:
				parent.dot_mesh.visible = true
				parent.arrow_mesh.visible = false
			else:
				parent.dot_mesh.visible = false
				parent.arrow_mesh.visible = true
			parent.global_rotation.z = 0
			
			match parent.direction:
				0:
					parent.global_rotation.z = deg_to_rad(180.0)
				1:
					parent.global_rotation.z = deg_to_rad(0.0)
				2:
					parent.global_rotation.z = deg_to_rad(-90.0)
				3:
					parent.global_rotation.z = deg_to_rad(90.0)
				4:
					parent.global_rotation.z = deg_to_rad(225.0)
				5:
					parent.global_rotation.z = deg_to_rad(135.0)
				6:
					parent.global_rotation.z = deg_to_rad(-45.0)
				7:
					parent.global_rotation.z = deg_to_rad(45.0)

			parent.global_rotation.z -= deg_to_rad(parent.angle_offset)

func update_position(update_x : bool, update_y : bool, update_z : bool):
	if update_x:
		parent.position.x = -1.5 + parent.x
	if update_y:
		parent.position.y = 0.5 + parent.y
	if update_z:
		parent.position.z = (parent.beat - parent.editor_node.current_beat) * -4
