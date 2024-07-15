extends Area3D

var highlighted = false

func _mouse_enter() -> void:
	if Input.is_key_pressed(KEY_SHIFT):
		$MeshInstance3D.transparency = 0.3
	else:
		$MeshInstance3D.transparency = 0.6
	highlighted = true
	

func _mouse_exit() -> void:
	$MeshInstance3D.transparency = 1
	highlighted = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_key_pressed(KEY_SHIFT) && highlighted:
			$MeshInstance3D.transparency = 0.3
		elif highlighted:
			$MeshInstance3D.transparency = 0.6
