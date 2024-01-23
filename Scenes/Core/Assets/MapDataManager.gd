class_name MapDataManager 
extends Node 
## Node for Managing and Updating Map Data (Info.dat).
## Cannonically known as MapDataer.
## Not known as this in editor for self-debugging and readability's sake.

@export var path : String
var info_dat : FileAccess
@export var info_dat_data : BeatmapInfo


func _ready() -> void:
	info_dat = FileAccess.open(path + "/Info.dat", FileAccess.READ_WRITE)
	info_dat_data = info_dat_data.unpack_from_json(info_dat.get_as_text())
	print("Map Loaded into RAM, setting variables.")
