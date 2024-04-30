class_name EventManager
extends Node
## Syncs the Realtime Editor view with the State relative to the MapData
## Manages and Validates all EditEvents before forwarding them to affected nodes and ultimately MapData
## Makes sure everything is in place

@export var editor_node : LucidiumEditor

func scroll_map(up: bool):
	var divisor = editor_node.current_precision_denominator
	if up:
		editor_node.current_beat = editor_node.current_beat + (1.0/divisor)
	else:
		editor_node.current_beat = editor_node.current_beat - (1.0/divisor)
