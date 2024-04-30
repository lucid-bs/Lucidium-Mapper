class_name MapData
extends Node
## Manages the local Memory version of the map and the Disk versionj
## Performs operations on map data

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_in_range(object_type, min_beat: float, max_beat: float) -> Array:
	var tmp : Array[VisualEventBS] = []
	
	return tmp.filter(func(obj): return obj.beat >= min_beat and obj.beat <= max_beat)
	
