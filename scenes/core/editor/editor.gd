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

@export var main_precision_denominator : int = 2
@export var secondary_precision_denominator : int = 2

@export var secondary_precision := false

@export var main_precision_container : PrecisionContainer

@export var secondary_precision_container : PrecisionContainer

@export var unsaved_changes : bool = false

@export var map_playing : bool

@export var audio_stream_player : AudioStreamPlayer

@export var sfx_player : AudioStreamPlayer

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("swap_precision"):
		swap_precisions()

func _ready() -> void:
	if main_precision_container:
		main_precision_container.positive_button.pressed.connect(update_precision.bind(true, false))
		main_precision_container.negative_button.pressed.connect(update_precision.bind(false, false))
	if secondary_precision_container:
		secondary_precision_container.positive_button.pressed.connect(update_precision.bind(true, true))
		secondary_precision_container.negative_button.pressed.connect(update_precision.bind(false, true))

func update_precision(positive : bool, secondary := false):
	current_precision_denominator = secondary_precision_denominator if secondary else main_precision_denominator
	if positive:
		current_precision_denominator *= 2
		clampi(current_precision_denominator, 1, 256)
	else:
		current_precision_denominator /= 2
		clampi(current_precision_denominator, 1, 256)
	if secondary:
		secondary_precision = true
		secondary_precision_denominator = current_precision_denominator
		secondary_precision_container.precision_label.text = "1/" + str(current_precision_denominator)
		if positive:
			secondary_precision_container.positive_button.hide()
			secondary_precision_container.positive_button.show()
		else:
			secondary_precision_container.negative_button.hide()
			secondary_precision_container.negative_button.show()
	else:
		secondary_precision = false
		main_precision_denominator = current_precision_denominator
		main_precision_container.precision_label.text = "1/" + str(current_precision_denominator)
		if positive:
			main_precision_container.positive_button.hide()
			main_precision_container.positive_button.show()
		else:
			main_precision_container.negative_button.hide()
			main_precision_container.negative_button.show()

func swap_precisions():
	if secondary_precision:
		secondary_precision_container.get_parent().add_theme_stylebox_override("panel", main_precision_container.get_parent().get_theme_stylebox("panel"))
		main_precision_container.get_parent().remove_theme_stylebox_override("panel")
	else:
		main_precision_container.get_parent().add_theme_stylebox_override("panel", secondary_precision_container.get_parent().get_theme_stylebox("panel"))
		secondary_precision_container.get_parent().remove_theme_stylebox_override("panel")
	secondary_precision = !secondary_precision
