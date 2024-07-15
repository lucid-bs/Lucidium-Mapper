class_name LucidiumEditor
extends Node
## Manages Beat, Audio Playback
## Exposes functions in one place for other nodes to call


signal setting_updated(setting : String, old_value, new_value)

signal beat_changed(new_beat : float)

@export var current_beat : float = 0:
	set(value):
		current_beat = value
		beat_changed.emit(value)

@export var current_precision_denominator : int = 2

@export var unsaved_changes : bool = false

@export var map_playing : bool

@export var audio_stream_player : AudioStreamPlayer

@export var sfx_player : AudioStreamPlayer
