class_name Beatmap
extends Resource

@export var version : String = "3.2.0"

@export var raw_data : Dictionary

var conversion_table_to_json = {
	"color_notes" = "colorNotes",
	"bomb_notes" = "bombNotes",
}

@export var bpm_events : Array
@export var rotation_events : Array
@export var color_notes : Array[ColorNote]
@export var bomb_notes : Array[BombNote]
@export var obstacles : Array
@export var sliders : Array
@export var burst_sliders : Array

@export var basic_beatmap_events : Array
@export var color_boost_beatmap_events : Array
@export var light_color_event_box_groups : Array
@export var light_rotation_event_box_groups : Array
@export var light_translation_event_box_groups : Array
@export var basic_event_types_with_keywords : Dictionary
@export var use_normal_events_as_compatible_events : bool = false
@export var custom_data : Dictionary 

func unpack_from_json(json_text : String, json : Dictionary = {}):
	if json.is_empty():
		json = JSON.parse_string(json_text)
	
	raw_data = json
	
	for i in raw_data[conversion_table_to_json["color_notes"]]:
		var new_note = ColorNote.new()
		color_notes.append(new_note.unpack_from_json("", i))
	for i in raw_data[conversion_table_to_json["bomb_notes"]]:
		var new_note = BombNote.new()
		bomb_notes.append(new_note.unpack_from_json("", i))
	

func pack_to_json():
	pass
