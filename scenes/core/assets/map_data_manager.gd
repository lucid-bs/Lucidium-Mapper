class_name MapDataManager 
extends Node 
## Node for Managing and Updating Map Data (Info.dat).
## Cannonically known as MapDataer.
## Not known as this in editor for self-debugging and readability's sake.

@export var path : String

@export var info_dat_data : BeatmapInfo

var info_dat : FileAccess

signal data_loaded

func update_property(property_name : StringName, new_property):
	match property_name:
		&"song_name":
			info_dat_data.song_name = new_property
		&"song_subname":
			info_dat_data.song_subname = new_property
		&"song_author_name":
			info_dat_data.song_author_name = new_property
		&"level_author_name":
			info_dat_data.level_author_name = new_property
		&"cover_image_filename":
			info_dat_data.cover_image_filename = new_property
		&"song_filename":
			info_dat_data.song_filename = new_property
		&"beats_per_minute":
			info_dat_data.beats_per_minute = new_property
		&"preview_start":
			info_dat_data.preview_start = new_property
		&"preview_duration":
			info_dat_data.preview_duration = new_property

func get_property(property_name : StringName):
	match property_name:
		&"song_name":
			return info_dat_data.song_name
		&"song_subname":
			return info_dat_data.song_subname
		&"song_author_name":
			return info_dat_data.song_author_name
		&"level_author_name":
			return info_dat_data.level_author_name
		&"cover_image_filename":
			return info_dat_data.cover_image_filename
		&"song_filename":
			return info_dat_data.song_filename
		&"beats_per_minute":
			return info_dat_data.beats_per_minute
		&"preview_start":
			return info_dat_data.preview_start
		&"preview_duration":
			return info_dat_data.preview_duration

func get_difficulty(difficulty_set : StringName, difficulty_name : StringName) -> DifficultyBeatmap:
	var target_set : BeatmapSet = null
	for i in info_dat_data.difficulty_beatmap_sets:
		if i.beatmap_characteristic_name == difficulty_set:
			target_set = i
	if target_set != null:
		for i in target_set.difficulty_beatmaps:
			if i.difficulty == difficulty_name:
				return i
	return null

func _ready() -> void:
	info_dat = FileAccess.open(path + "/Info.dat", FileAccess.READ_WRITE)
	if info_dat == null:
		info_dat = FileAccess.open(path + "/info.dat", FileAccess.READ_WRITE)
	info_dat_data.unpack_from_json(info_dat.get_as_text())
	print("Map Loaded into RAM, setting variables.")
	data_loaded.emit()
