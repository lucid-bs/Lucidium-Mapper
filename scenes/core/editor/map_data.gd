class_name MapData
extends Node
## Manages the local Memory version of the map and the Disk version
## Performs operations on map data

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func get_in_range(object_type : StringName, min_beat: float, max_beat: float) -> Array:
	var tmp : Array
	match object_type:
		&"color_notes":
			tmp = $"../..".beatmap.color_notes
	
	return tmp.filter(func(obj): return obj.beat >= min_beat and obj.beat <= max_beat)
	
