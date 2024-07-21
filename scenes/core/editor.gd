extends Node3D

@export var local_editor : LucidiumEditor

@export var difficulty_beatmap  : DifficultyBeatmap = DifficultyBeatmap.new()
@export var beatmap : Beatmap = Beatmap.new()

@export var audio_stream : AudioStream

@export var map_path : String

@export var current_bpm : float 

signal mapper_ready

func _on_exit_pressed() -> void:
	if $LucidiumEditor.unsaved_changes:
		$ExitConfirmation.show()
	else:
		var map_config = load("res://scenes/core/map_configurer.tscn").instantiate()
		map_config.map_data_manager.path = map_path
		
		get_tree().root.call_deferred("add_child", map_config)
		call_deferred("queue_free")

func _ready() -> void:
	if beatmap.raw_data.is_empty():
		var beatmap_raw_data = FileAccess.get_file_as_string(map_path + difficulty_beatmap.beatmap_filename)
		beatmap.unpack_from_json(beatmap_raw_data)
		
	$LucidiumEditor/EventManager.sync_blocks()
	
	mapper_ready.emit()
	
	$LucidiumEditor/AudioStreamPlayer.stream = audio_stream
	
