class_name BeatmapInfo
extends Resource

var raw_data : Dictionary

@export var version : String = "2.1.0"
@export var song_name : String
@export var song_submane : String
@export var song_author_name : String
@export var level_author : String

@export var audio_bpm : float

@export var shuffle : float = 0.0
@export var shuffle_period : float = 0.0

@export var preview_start : float
@export var preview_duration : float

@export var cover_filename : String
@export var audio_filename : String

@export var environment_name : String
@export var all_directions_environment_name : String = "GlassDesertEnvironment"

@export var song_offset_time : float = 0.0

@export var environment_names : Array[String] = []
@export var color_schemes : Dictionary

@export var custom_data : Dictionary
@export var difficulty_beatmap_sets : Array


func unpack_from_json(json_text : String, json : Dictionary = {}):
	if json.is_empty():
		json = JSON.parse_string(json_text)
	
	raw_data = json
	

func pack_to_json():
	pass
