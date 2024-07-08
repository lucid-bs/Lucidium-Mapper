class_name EventManager
extends Node
## Syncs the Realtime Editor view with the State relative to the MapData
## Manages and Validates all EditEvents before forwarding them to affected nodes and ultimately MapData
## Makes sure everything is in place

@export var editor_node : LucidiumEditor
@export var map_data : MapData

const BLOCK = preload("res://scenes/core/editor/block.tscn")

var current_active_blocks : Array[ColorNote]
func scroll_map(up: bool):
	var divisor = editor_node.current_precision_denominator
	if up:
		editor_node.current_beat = editor_node.current_beat + (1.0/divisor)
	else:
		editor_node.current_beat = editor_node.current_beat - (1.0/divisor)

func sync_blocks():
	var notes = map_data.get_in_range(&"color_notes", editor_node.current_beat, editor_node.current_beat + 7)
	
	var old_blocks : Array[Node] = $"../../Bloqs".get_children()
	for i : ColorNote in notes:
		if i.get_meta(&"block_node") is Block:
			i.get_meta(&"block_node").position.z = (i.beat - editor_node.current_beat) * -4
			old_blocks.erase(i.get_meta(&"block_node"))
			
		else:
			var new_block = BLOCK.instantiate()
			new_block.color_note_resource = i
			new_block.x = i.line_index
			new_block.y = i.line_layer
			new_block.color = i.color
			new_block.direction = i.cut_direction
			new_block.angle_offset = i.angle_offset
			new_block.beat = i.beat
			$"../../Bloqs".add_child(new_block)
			new_block.position.z = (i.beat - editor_node.current_beat) * -4
			i.set_meta(&"block_node", new_block)
		
			
	for i in old_blocks:
		i.queue_free()
