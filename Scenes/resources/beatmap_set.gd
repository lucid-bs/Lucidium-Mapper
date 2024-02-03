class_name BeatmapSet
extends Resource

var raw_data : Dictionary

@export var beatmap_characteristic_name : String = "Standard"
@export var difficulty_beatmaps : Array[DifficultyBeatmap]

var conversion_table_to_json = {
	"beatmap_characteristic_name" = "_beatmapCharacteristicName",
	"difficulty_beatmaps" = "_difficultyBeatmaps",
}

func unpack_from_json(json_text : String, json : Dictionary = {}) -> BeatmapSet:
	if json.is_empty():
		json = JSON.parse_string(json_text)
	raw_data = json
	
	beatmap_characteristic_name = raw_data[conversion_table_to_json["beatmap_characteristic_name"]]
	for i in raw_data[conversion_table_to_json["difficulty_beatmaps"]]:
		var db = DifficultyBeatmap.new()
		difficulty_beatmaps.append(db.unpack_from_json("", i))
	return self

func pack_to_json():
	pass
