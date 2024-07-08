class_name BeatmapInfo
extends Resource

var raw_data : Dictionary

@export var version : String = "2.1.0"
@export var song_name : String
@export var song_subname : String
@export var song_author_name : String
@export var level_author_name : String

@export var beats_per_minute : float

@export var shuffle : float = 0.0
@export var shuffle_period : float = 0.5

@export var preview_start : float
@export var preview_duration : float

@export var song_filename : String
@export var cover_image_filename : String

@export var environment_name : String
@export var all_directions_environment_name : String = "GlassDesertEnvironment"

@export var song_time_offset : float = 0.0

@export var environment_names : Array[String] = []
@export var color_schemes : Array

@export var custom_data : Dictionary
@export var difficulty_beatmap_sets : Array[BeatmapSet]

var conversion_table_to_json = {
	"song_name" = "_songName",
	"song_subname" = "_songSubName",
	"song_author_name" = "_songAuthorName",
	"level_author_name" = "_levelAuthorName",
	"beats_per_minute" = "_beatsPerMinute",
	"shuffle" = "_shuffle",
	"shuffle_period" = "_shufflePeriod",
	"preview_start_time" = "_previewStartTime",
	"preview_duration" = "_previewDuration",
	"song_filename" = "_songFilename",
	"cover_image_filename" = "_coverImageFilename",
	"environment_name" = "_environmentName",
	"all_directions_environment_name" = "_allDirectionsEnvironmentName",
	"song_time_offset" = "_songTimeOffset",
	"environment_names" = "_environmentNames",
	"color_schemes" = "_colorSchemes",
	"custom_data" = "_customData",
	"difficulty_beatmap_sets" = "_difficultyBeatmapSets",
}

### Converts the Raw JSON data into a new BeatmapInfo object
func unpack_from_json(json_text : String, json : Dictionary = {}) -> BeatmapInfo:
	if json.is_empty():
		json = JSON.parse_string(json_text)
	
	raw_data = json
	
	song_name = raw_data[conversion_table_to_json["song_name"]]
	song_subname = raw_data[conversion_table_to_json["song_subname"]]
	song_author_name = raw_data[conversion_table_to_json["song_author_name"]]
	level_author_name = raw_data[conversion_table_to_json["level_author_name"]]
	beats_per_minute = raw_data[conversion_table_to_json["beats_per_minute"]]
	shuffle = raw_data[conversion_table_to_json["shuffle"]]
	shuffle_period = raw_data[conversion_table_to_json["shuffle_period"]]
	preview_start = raw_data[conversion_table_to_json["preview_start_time"]]
	preview_duration = raw_data[conversion_table_to_json["preview_duration"]]
	song_filename = raw_data[conversion_table_to_json["song_filename"]]
	cover_image_filename = raw_data[conversion_table_to_json["cover_image_filename"]]
	environment_name = raw_data[conversion_table_to_json["environment_name"]]
	song_time_offset = raw_data[conversion_table_to_json["song_time_offset"]]
	
	for i in raw_data[conversion_table_to_json["difficulty_beatmap_sets"]]:
		var bs = BeatmapSet.new()
		difficulty_beatmap_sets.append(bs.unpack_from_json("i", i))
	
	# Check if keys exist in dictionary
	
	if raw_data.has(conversion_table_to_json["all_directions_environment_name"]):
		all_directions_environment_name = raw_data[conversion_table_to_json["all_directions_environment_name"]]
	if raw_data.has(conversion_table_to_json["custom_data"]):
		custom_data = raw_data[conversion_table_to_json["custom_data"]]
		
	if raw_data.has(conversion_table_to_json["color_schemes"]):
		color_schemes = raw_data[conversion_table_to_json["color_schemes"]]

	# Check if array is not empty
	if raw_data.has(conversion_table_to_json["environment_names"]) and raw_data[conversion_table_to_json["environment_names"]].size() > 0:
		environment_names = raw_data[conversion_table_to_json["environment_names"]]
	
	return self

func pack_to_json():
	pass
