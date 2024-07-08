class_name DifficultyThingy
extends Panel

## Yup, that's its official name now.
## I can't be bothered to come up with an original, sensible one so it's staying like this
## You're welcome to make a PR if it bothers you that much
## And I will be welcome to deny said pr at my discretion :P


signal copy_status_changed(copying: bool)

signal difficulty_changed(new_difficulty: DifficultyThingyDiff)

@export var map_data_manager : MapDataManager

@export var copy_pending : bool = false

@export var current_copy_node : CopyButtons

@export var current_difficulty : DifficultyThingyDiff


var map_reaction_time : float = 0:
	set(value):
		$HFlowContainer/ReactionTime/SpinBox.value = value
		map_reaction_time = value
var map_jump_distance : float = 0:
	set(value):
		$HFlowContainer/JumpDistance/SpinBox.value = value
		map_jump_distance = value
var map_half_jump_duration : float = 0:
	set(value):
		$HFlowContainer/HalfJumpDuration/SpinBox.value = value
		map_half_jump_duration = value
var map_note_jump_speed : float = 0:
	set(value):
		$HFlowContainer/NoteJumpSpeed/SpinBox.value = value
		map_note_jump_speed = value
var map_start_beat_offset : float = 0:
	set(value):
		$HFlowContainer/StartBeatOffset/SpinBox.value = value
		map_start_beat_offset = value
var map_bpm : float = 0

## full credit goes to Caeden117 (and KivalEvan) for all of the code in this function lmao
func calculate_half_jump_duration(note_jump_speed : float, start_beat_offset: float, bpm : float):
	var half_jump_duration = 4.0
	var num = 60 / bpm

	while (note_jump_speed * num * half_jump_duration > 17.999):
		half_jump_duration /= 2

	half_jump_duration += start_beat_offset

	if (half_jump_duration < 0.25): half_jump_duration = 0.25

	return half_jump_duration;

## ~partial~ full credit goes to Caeden117 for ~most~ all of the code in this function lmao
func update_controls():
	map_note_jump_speed = current_difficulty.difficulty_object.note_jump_movement_speed
	map_start_beat_offset = current_difficulty.difficulty_object.note_jump_start_beat_offset
	map_half_jump_duration = calculate_half_jump_duration(current_difficulty.difficulty_object.note_jump_movement_speed, 
		current_difficulty.difficulty_object.note_jump_start_beat_offset, 
		map_data_manager.get_property(&"beats_per_minute"))
	map_bpm = 60 / map_data_manager.get_property(&"beats_per_minute")
	map_jump_distance = current_difficulty.difficulty_object.note_jump_movement_speed * map_bpm * map_half_jump_duration * 2;

	var beatms = 60000 / map_data_manager.get_property(&"beats_per_minute");
	map_reaction_time = beatms * map_half_jump_duration;

func update_values_from_reaction_time():
	set_song_beat_offset(maxf(0.25, map_reaction_time  / ((60000 / map_bpm))))
func update_values_from_jump_distance():
	set_song_beat_offset(maxf(0.25, map_jump_distance / ((60 / map_bpm) * map_note_jump_speed * 2)))
func update_values_from_half_jump_duration():
	set_song_beat_offset(maxf(0.25, map_half_jump_duration))

func set_song_beat_offset(hjd_after_offset : float):
	var hjd_before_offset = calculate_half_jump_duration(map_note_jump_speed, 0, map_bpm)
	map_start_beat_offset = hjd_after_offset - hjd_before_offset


func _on_reaction_time_value_changed(value: float) -> void:
	map_reaction_time = value
	update_values_from_reaction_time()

func _on_jump_distance_value_changed(value: float) -> void:
	map_jump_distance = value
	update_values_from_jump_distance()
	
func _on_half_jump_duration_value_changed(value: float) -> void:
	map_half_jump_duration = value
	update_values_from_half_jump_duration()
