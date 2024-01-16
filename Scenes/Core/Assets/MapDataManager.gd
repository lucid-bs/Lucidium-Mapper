class_name MapDataManager 
extends Node 
## Node for Managing and Updating Map Data (Info.dat).
## Cannonically known as MapDataer.
## Not known as this in editor for self-debugging and readability's sake.

var path : String
var info_dat : FileAccess
var info_dat_data : Dictionary

var version : String = "2.1.0"
var song_name : String
var song_submane : String
var song_author_name : String
var level_author : String

var audio_bpm : float

var shuffle : float = 0.0
var shuffle_period : float = 0.0

var preview_start : float
var preview_duration : float

var cover_filename : String
var audio_filename : String

var environment_name : String
var all_directions_environment_name : String = "GlassDesertEnvironment"

var song_offset_time : float = 0.0

var environment_names : Array[String] = []
var color_schemes : Dictionary

var custom_data : Dictionary
var difficulty_beatmap_sets : Array

func _ready() -> void:
	info_dat = FileAccess.open(path + "/Info.dat", FileAccess.READ_WRITE)
	info_dat_data = JSON.parse_string(info_dat.get_as_text())
	print("Map Loaded into RAM, setting variables.")
