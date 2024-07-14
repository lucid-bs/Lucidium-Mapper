class_name PlayerController
extends Node
# Manages Keybinds, editor cursor stuff
# Manages Selection, creates EditEvents

signal player_scrolled(up: bool)

@export var event_manager : EventManager
@export var editor_node : LucidiumEditor

var playback_node : MapPlayback

func _input(event: InputEvent) -> void:
	if event.is_action("map_scroll_up") && event.is_pressed() && !editor_node.map_playing:
		event_manager.scroll_map(true)
		editor_node.audio_stream_player.play((60/$"../..".current_bpm) * editor_node.current_beat)
		await get_tree().create_timer(0.13).timeout
		editor_node.audio_stream_player.stop()
	elif event.is_action("map_scroll_down") && event.is_pressed() && !editor_node.map_playing:
		event_manager.scroll_map(false)
		editor_node.audio_stream_player.play((60/$"../..".current_bpm) * editor_node.current_beat)
		await get_tree().create_timer(0.13).timeout
		editor_node.audio_stream_player.stop()
		
		
	elif event.is_action("map_play_pause") && event.is_pressed():
		if editor_node.map_playing:
			var divisor = editor_node.current_precision_denominator
			editor_node.map_playing = false
			editor_node.audio_stream_player.stop()
			playback_node.queue_free()
			editor_node.current_beat = snappedf(editor_node.current_beat, (1.0/divisor))
			event_manager.sync_blocks()
		else:
			editor_node.audio_stream_player.stream =  $"../..".audio_stream
			editor_node.audio_stream_player.play((60/$"../..".current_bpm) * editor_node.current_beat)
			editor_node.map_playing = true
			
			playback_node = MapPlayback.new()
			playback_node.editor_node = editor_node
			playback_node.event_manager = event_manager
			editor_node.add_child(playback_node)
			
