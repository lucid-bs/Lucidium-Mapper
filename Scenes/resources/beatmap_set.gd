class_name BeatmapSet
extends Resource

var raw_data : Dictionary

@export var characteristic_name : String = "Standard"
@export var difficulty_beatmaps : Array[DifficultyBeatmap]


func unpack_from_json(json_text : String, json : Dictionary = {}):
	pass

func pack_to_json():
	pass
