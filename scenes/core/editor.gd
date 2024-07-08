extends Node3D

@export var local_editor : LucidiumEditor

@export var difficulty_beatmap  : DifficultyBeatmap = DifficultyBeatmap.new()
@export var beatmap : Beatmap = Beatmap.new()

@export var audio_stream : AudioStream

@export var map_path : String

func _on_exit_pressed() -> void:
	if $LucidiumEditor.unsaved_changes:
		$ExitConfirmation.show()

func _ready() -> void:
	if beatmap.raw_data.is_empty():
		var beatmap_raw_data = FileAccess.get_file_as_string(map_path + difficulty_beatmap.beatmap_filename)
		beatmap.unpack_from_json(beatmap_raw_data)
		
