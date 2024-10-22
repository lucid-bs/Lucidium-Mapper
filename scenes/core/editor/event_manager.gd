class_name EventManager
extends Node
## Syncs the Realtime Editor view with the State relative to the MapData
## Manages and Validates all EditEvents before forwarding them to affected nodes and ultimately MapData
## Makes sure everything is in place

@export var editor_node : LucidiumEditor
@export var map_data : MapData

const BLOCK = preload("res://scenes/core/editor/block.tscn")
const BOMB = preload("res://scenes/core/editor/bomb.tscn")
@export var bpm_second_rate : float

@export var active_notes : Array

var current_active_blocks : Array[ColorNote]
func scroll_map(up: bool):
	var step = 1.0 / editor_node.current_precision_denominator
	if up:
		editor_node.current_beat += step
		editor_node.current_beat = clampf(snappedf(editor_node.current_beat, step), 0.0, ($"../..".current_bpm / 60) * $"../..".audio_stream.get_length())
	else:
		editor_node.current_beat -= step
		editor_node.current_beat = clampf(snappedf(editor_node.current_beat, step), 0.0, ($"../..".current_bpm / 60) * $"../..".audio_stream.get_length())
	sync_blocks()
	sync_bombs()
	
	
func sync_blocks():
	var block_tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_parallel()
	active_notes = map_data.get_in_range(&"color_notes", editor_node.current_beat - 2, editor_node.current_beat + 7)
	
	var old_blocks : Array[Node] = $"../../Bloqs".get_children()
	for i : ColorNote in active_notes:
		var temp = i.get_meta(&"block_node", "null")
		if temp is Block:
			temp.transform_component.update_position(false, false, true)
			if temp.beat < editor_node.current_beat:
				block_tween.tween_property(temp, "block_dissolve", 0.5, 0.1)
				#temp.block_dissolve = 0.5
				block_tween.tween_property(temp, "arrow_dissolve", 0.5, 0.1)
				#temp.arrow_dissolve = 0.5
			else:
				#temp.block_dissolve = 1
				block_tween.tween_property(temp, "block_dissolve", 1, 0.1)
				#temp.arrow_dissolve = 1
				block_tween.tween_property(temp, "arrow_dissolve", 1, 0.1)
			old_blocks.erase(temp)
			
		else:
			var new_block = BLOCK.instantiate()
			new_block.editor_node = editor_node
			new_block.color_note_resource = i
			new_block.x = i.line_index
			new_block.y = i.line_layer
			new_block.position = Vector3(1, 1, 1)
			new_block.color = i.color
			new_block.direction = i.cut_direction
			new_block.angle_offset = i.angle_offset
			new_block.beat = i.beat
			new_block.error_logger = %ErrorLogger
			$"../../Bloqs".add_child(new_block)
			new_block.transform_component.update_position(false, false, true)
			if new_block.beat < editor_node.current_beat:
				block_tween.tween_property(new_block, "block_dissolve", 0.5, 0.1)
				#temp.block_dissolve = 0.5
				block_tween.tween_property(new_block, "arrow_dissolve", 0.5, 0.1)
				#temp.arrow_dissolve = 0.5
			else:
				#temp.block_dissolve = 1
				block_tween.tween_property(new_block, "block_dissolve", 1, 0.1)
				#temp.arrow_dissolve = 1
				block_tween.tween_property(new_block, "arrow_dissolve", 1, 0.1)
			i.set_meta(&"block_node", new_block)
			
	for i : Block in old_blocks:
		i.color_note_resource.set_meta(&"block_node", null)
		block_tween.tween_callback(i.queue_free)
		
func sync_bombs():
	active_notes = map_data.get_in_range(&"bomb_notes", editor_node.current_beat - 2, editor_node.current_beat + 7)
	
	var old_bombs : Array[Node] = $"../../Bombs".get_children()
	for i : BombNote in active_notes:
		var temp = i.get_meta(&"bomb_note", "null")
		if temp is Bomb:
			temp.transform_component.update_position(false, false, true)
			old_bombs.erase(temp)
		else:
			var new_bomb = BOMB.instantiate()
			new_bomb.editor_node = editor_node
			new_bomb.bomb_note_resource = i
			new_bomb.x = i.line_index
			new_bomb.y = i.line_layer
			new_bomb.position = Vector3(1, 1, 1)
			new_bomb.beat = i.beat
			new_bomb.error_logger = %ErrorLogger
			$"../../Bombs".add_child(new_bomb)
			new_bomb.transform_component.update_position(false, false, true)
			i.set_meta(&"bomb_note", new_bomb)
			
	for i : Bomb in old_bombs:
		i.bomb_note_resource.set_meta(&"bomb_note", null)
		i.queue_free()
		
