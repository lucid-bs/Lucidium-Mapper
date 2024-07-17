extends Node3D

@export var editor_node : LucidiumEditor

@export var bar_mesh : Mesh

@export var bar_material : Material

@export var bar_offset : float

func _ready() -> void:
	editor_node.beat_changed.connect(update_beat_bars)
	create_beat_bars()
	position.z = 4

func update_beat_bars(new_beat : float):
	var ceil_beat = ceil(new_beat)
	var z_offset = ceil_beat - new_beat - 1
	position.z = z_offset * -4 + 4
	
func create_beat_bars():
	bar_offset = 4 / editor_node.current_precision_denominator
	for i in get_children():
		i.queue_free()
	var bars_to_create = 9 * editor_node.current_precision_denominator
	var iterator = 1
	while bars_to_create > 0:
		var new_bar= MeshInstance3D.new()
		new_bar.mesh = bar_mesh
		new_bar.material_override = bar_material
		add_child(new_bar)
		new_bar.rotate_z(deg_to_rad(90))
		new_bar.position.z = -4 / editor_node.current_precision_denominator * iterator
		iterator += 1
		bars_to_create -= 1
