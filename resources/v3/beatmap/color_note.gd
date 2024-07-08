class_name ColorNote
extends Resource

@export var raw_data : Dictionary

var conversion_table_to_json = {
	"beat" =  "b",
	"line_index" =  "x",
	"line_layer" =  "y",
	"color" =  "c",
	"cut_direction" =  "d",
	"angle_offset" =  "a",
}

@export var beat : float
@export var line_index : int
@export var line_layer : int
@export var color : int
@export var cut_direction : int
@export var angle_offset : float
@export var custom_data : Dictionary

func unpack_from_json(json_text : String, json : Dictionary = {}) -> ColorNote: 
	if json.is_empty():
		json = JSON.parse_string(json_text)
	
	raw_data = json
	
	beat = raw_data[conversion_table_to_json["beat"]]
	line_index = raw_data[conversion_table_to_json["line_index"]]
	line_layer = raw_data[conversion_table_to_json["line_layer"]]
	color = raw_data[conversion_table_to_json["color"]]
	cut_direction = raw_data[conversion_table_to_json["cut_direction"]]
	angle_offset = raw_data[conversion_table_to_json["angle_offset"]]
	
	return self
	
	
func pack_to_json():
	pass
