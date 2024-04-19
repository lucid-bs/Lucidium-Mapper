class_name EditorController
extends Node


signal scrolled(up : bool)

signal map_played()
signal map_stopped()

@export var map_playing : bool = false:
	set(value):
		map_playing = value
		if value:
			map_played.emit()
		else:
			map_stopped.emit()

