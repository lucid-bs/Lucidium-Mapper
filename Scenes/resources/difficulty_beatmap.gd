class_name DifficultyBeatmap
extends Resource


var raw_data : Dictionary

@export var difficulty : String = "ExpertPlus"
@export var difficulty_rank : int = 9
@export var beatmap_filename : String = "ExpertPlusStandard.dat"
@export var note_jump_movement_speed : float = 16
@export var note_jump_start_speed : float = 0

@export var custom_data : Dictionary

func unpack_from_json(json_text : String, json : Dictionary = {}):
	pass

func pack_to_json():
	pass
