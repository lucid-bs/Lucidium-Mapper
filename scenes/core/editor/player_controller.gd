class_name PlayerController
extends Node
# Manages Keybinds, editor cursor stuff
# Manages Selection, creates EditEvents

signal player_scrolled(up: bool)

@export var event_manager : EventManager
@export var editor_node : LucidiumEditor

@export var timeline_scroll_bar : HScrollBar



var playback_node : MapPlayback

func _input(event: InputEvent) -> void:
	if event.is_action("map_scroll_up") && event.is_pressed() && !editor_node.map_playing:
		event_manager.scroll_map(true)
		editor_node.audio_stream_player.play((60/$"../..".current_bpm) * editor_node.current_beat)
		await get_tree().create_timer(0.15).timeout
		editor_node.audio_stream_player.stop()
	elif event.is_action("map_scroll_down") && event.is_pressed() && !editor_node.map_playing:
		event_manager.scroll_map(false)
		editor_node.audio_stream_player.play((60/$"../..".current_bpm) * editor_node.current_beat)
		await get_tree().create_timer(0.15).timeout
		editor_node.audio_stream_player.stop()
		
		
	elif event.is_action("map_play_pause") && event.is_pressed():
		if editor_node.map_playing:
			var divisor = editor_node.current_precision_denominator
			editor_node.map_playing = false
			editor_node.audio_stream_player.stop()
			playback_node.queue_free()
			editor_node.current_beat = snappedf(editor_node.current_beat, (1.0/divisor))
			event_manager.sync_blocks()
			timeline_scroll_bar.value_changed.connect(scroll_bar_value_changed)
			
		else:
			editor_node.map_playing = true
			if editor_node.audio_stream_player.playing:
				await get_tree().create_timer(0.15).timeout
				editor_node.audio_stream_player.stop()
			editor_node.audio_stream_player.stream =  $"../..".audio_stream
			editor_node.audio_stream_player.play((60/$"../..".current_bpm) * editor_node.current_beat)
			
			
			playback_node = MapPlayback.new()
			playback_node.editor_node = editor_node
			playback_node.event_manager = event_manager
			editor_node.add_child(playback_node)
			timeline_scroll_bar.value_changed.disconnect(scroll_bar_value_changed)
			
			
func _ready() -> void:
	timeline_scroll_bar.step = 1.0 / editor_node.current_precision_denominator
	timeline_scroll_bar.max_value = ($"../..".current_bpm / 60) * $"../..".audio_stream.get_length()
	timeline_scroll_bar.value_changed.connect(scroll_bar_value_changed)
	editor_node.beat_changed.connect(editor_beat_changed)

func scroll_bar_value_changed(value):
	editor_node.current_beat = value
	event_manager.sync_blocks()
	editor_node.audio_stream_player.play((60/$"../..".current_bpm) * editor_node.current_beat)
	await get_tree().create_timer(0.13).timeout
	editor_node.audio_stream_player.stop()
	
func editor_beat_changed(value):
	timeline_scroll_bar.value_changed.disconnect(scroll_bar_value_changed)
	timeline_scroll_bar.value = value
	timeline_scroll_bar.value_changed.connect(scroll_bar_value_changed)
