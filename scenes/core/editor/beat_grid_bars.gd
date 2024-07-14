extends Node3D

@export var editor_node : LucidiumEditor

func _ready() -> void:
	editor_node.beat_changed.connect(update_beat_bars)

func update_beat_bars(new_beat : float):
	var ceil_beat = ceil(new_beat)
	var z_offset = ceil_beat - new_beat 
	position.z = z_offset * -4 
	
	
	$"0/BeatNum".text = str(ceil_beat - 1)
	$"1/BeatNum".text = str(ceil_beat)
	$"2/BeatNum".text = str(ceil_beat + 1)
	$"3/BeatNum".text = str(ceil_beat + 2)
	$"4/BeatNum".text = str(ceil_beat + 3)
	$"5/BeatNum".text = str(ceil_beat + 4)
	$"6/BeatNum".text = str(ceil_beat + 5)
	$"7/BeatNum".text = str(ceil_beat + 6)
	$"8/BeatNum".text = str(ceil_beat + 7)
		
	
