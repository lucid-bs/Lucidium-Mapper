extends Area3D

var highlighted = false

var current_block : Block

@export var editor_node : LucidiumEditor 

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
			
func _ready() -> void:
	body_entered.connect(_body_entered)
	body_exited.connect(_body_exited)

func _body_entered(body : Node3D):
	if body is Block && current_block == null:
		current_block = body
		editor_node.sfx_player.play()
		
func _body_exited(body : Node3D):
	if body is Block && current_block == body:
		current_block = null
