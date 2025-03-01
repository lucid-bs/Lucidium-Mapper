class_name MapPlayback
extends Node

@export var editor_node : LucidiumEditor
@export var event_manager : EventManager

@export var audio_stream : AudioStream
var bpm_second_rate : float

func _ready() -> void:
	editor_node.audio_stream_player.finished.connect(audio_stream_finished)
	
	editor_node.audio_stream_player.stream = audio_stream
	editor_node.audio_stream_player.play((60/$"../..".current_bpm) * editor_node.current_beat)
	editor_node.map_playing = true

func _process(delta: float) -> void:
	if editor_node.map_playing:
		# I don't understand why this is working
		# It's supposed to be the other way around
		# If you see this can you PLEASE explain it to me?
		bpm_second_rate = $"../..".current_bpm / 60
		editor_node.current_beat = (editor_node.audio_stream_player.get_playback_position() + AudioServer.get_time_since_last_mix()) * (bpm_second_rate)
		event_manager.sync_blocks()
		event_manager.sync_bombs()


func audio_stream_finished():
	editor_node.map_playing = false
	event_manager.sync_blocks()
	event_manager.sync_bombs()
	queue_free()
