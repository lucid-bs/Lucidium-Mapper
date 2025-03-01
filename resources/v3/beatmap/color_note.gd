class_name BombNote
extends Resource

@export var raw_data : Dictionary

var conversion_table_to_json = {
	"beat" =  "b",
	"line_index" =  "x",
	"line_layer" =  "y",
}

@export var beat : float
@export var line_index : int
@export var line_layer : int
@export var custom_data : Dictionary

func unpack_from_json(json_text : String, json : Dictionary = {}) -> BombNote: 
	if json.is_empty():
		json = JSON.parse_string(json_text)
	
	raw_data = json
	
	beat = raw_data[conversion_table_to_json["beat"]]
	line_index = raw_data[conversion_table_to_json["line_index"]]
	line_layer = raw_data[conversion_table_to_json["line_layer"]]
	
	return self
	
	
func pack_to_json():
	pass
