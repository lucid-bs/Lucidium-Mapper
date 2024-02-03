class_name DifficultyBeatmap
extends Resource


var raw_data : Dictionary

@export var difficulty : String = "ExpertPlus"
@export var difficulty_rank : int = 9
@export var beatmap_filename : String = "ExpertPlusStandard.dat"
@export var note_jump_movement_speed : float = 16
@export var note_jump_start_speed : float = 0
@export var beatmap_color_scheme_idx : int = 0
@export var environment_name_idx : int = 0

@export var custom_data : Dictionary

var conversion_table_to_json = {
	"difficulty" = "_difficulty",
	"difficulty_rank" = "_difficultyRank",
	"beatmap_filename" = "_beatmapFilename",
	"note_jump_movement_speed" = "_noteJumpMovementSpeed",
	"note_jump_start_speed" = "_noteJumpStartBeatOffset",
	"beatmap_color_scheme_idx" = "_beatmapColorSchemeIdx",
	"environment_name_idx" = "_environmentNameIdx",
	"custom_data" = "_customData",
}


func unpack_from_json(json_text : String, json : Dictionary = {}) -> DifficultyBeatmap:
	if json.is_empty():
		json = JSON.parse_string(json_text)
	raw_data = json
	
	difficulty = raw_data[conversion_table_to_json["difficulty"]]
	difficulty_rank = raw_data[conversion_table_to_json["difficulty_rank"]]
	beatmap_filename = raw_data[conversion_table_to_json["beatmap_filename"]]
	note_jump_movement_speed = raw_data[conversion_table_to_json["note_jump_movement_speed"]]
	note_jump_start_speed = raw_data[conversion_table_to_json["note_jump_start_speed"]]
	
	if raw_data.has(conversion_table_to_json["beatmap_color_scheme_idx"]):
		beatmap_color_scheme_idx = raw_data[conversion_table_to_json["beatmap_color_scheme_idx"]]
	if raw_data.has(conversion_table_to_json["environment_name_idx"]):
		environment_name_idx = raw_data[conversion_table_to_json["environment_name_idx"]]
	if raw_data.has(conversion_table_to_json["custom_data"]):
		custom_data = raw_data[conversion_table_to_json["custom_data"]]
	return self

func pack_to_json():
	pass
