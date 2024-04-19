extends Node3D

@export var beatwalls_schema : bool

func set_schema(using_beatwalls : bool):
	if using_beatwalls:
		$Y.position.y = 0.5
		$Y/Y0.text = "1"
		$Y/Y1.text = "2"
		$Y/Y2.text = "3"
		$"1X".position.x = -0.5
		$"1X/X0".text = "-2"
		$"1X/X1".text = "-1"
		$"2X".position.x = 0.5
		$"2X/X2".text = "1"
		$"2X/X3".text = "2"
	else:
		$Y.position.y = 0
		$Y/Y0.text = "0"
		$Y/Y1.text = "1"
		$Y/Y2.text = "2"
		$"1X".position.x = 0
		$"1X/X0".text = "0"
		$"1X/X1".text = "1"
		$"2X".position.x = 0
		$"2X/X2".text = "2"
		$"2X/X3".text = "3"

func _ready() -> void:
	set_schema(beatwalls_schema)
