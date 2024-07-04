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
	$HFlowContainer/NoteJumpSpeed/SpinBox.value = current_difficulty.difficulty_object.note_jump_movement_speed
	$HFlowContainer/StartBeatOffset/SpinBox.value = current_difficulty.difficulty_object.note_jump_start_beat_offset
	$HFlowContainer/HalfJumpDuration/SpinBox.value = calculate_half_jump_duration(current_difficulty.difficulty_object.note_jump_movement_speed, 
		current_difficulty.difficulty_object.note_jump_start_beat_offset, 
		map_data_manager.get_property(&"beats_per_minute"))
	var num = 60 / map_data_manager.get_property(&"beats_per_minute");
	$HFlowContainer/JumpDistance/SpinBox.value = current_difficulty.difficulty_object.note_jump_movement_speed * num * $HFlowContainer/HalfJumpDuration/SpinBox.value * 2;

	var beatms = 60000 / map_data_manager.get_property(&"beats_per_minute");
	$HFlowContainer/ReactionTime/SpinBox.value = beatms * $HFlowContainer/HalfJumpDuration/SpinBox.value;
