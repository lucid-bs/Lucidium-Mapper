class_name CopyButtons
extends HBoxContainer

@export var difficulty_thingy : DifficultyThingy

func _ready() -> void:
	$Copy.visible = true
	$Paste.visible = false
	$Notes.visible = false
	$Environment.visible = false
	$Lights.visible = false
	$Copy.toggled.connect(copy_button_toggled)
	difficulty_thingy.copy_status_changed.connect(global_copy_changed)

func copy_button_toggled(toggled_on: bool):
	if !toggled_on:
		$Paste.visible = false
		$Notes.visible = false
		$Environment.visible = false
		$Lights.visible = false
		difficulty_thingy.copy_pending = false
		difficulty_thingy.copy_status_changed.emit(false)
	elif toggled_on:
		difficulty_thingy.copy_status_changed.disconnect(global_copy_changed)
		difficulty_thingy.current_copy_node = self
		$Paste.visible = false
		$Notes.visible = true
		$Notes.button_pressed = true
		$Environment.visible = true
		$Environment.button_pressed = true
		$Lights.visible = true
		$Lights.button_pressed = true
		difficulty_thingy.copy_pending = true
		difficulty_thingy.copy_status_changed.emit(true)
		difficulty_thingy.copy_status_changed.connect(global_copy_changed)
	elif !difficulty_thingy.copy_pending:
		$Paste.visible = false
		$Notes.visible = false
		$Environment.visible = false
		$Lights.visible = false
	elif difficulty_thingy.copy_pending:
		$Paste.visible = true
		$Notes.visible = false
		$Environment.visible = false
		$Lights.visible = false
	else:
		$Paste.visible = false
		$Notes.visible = false
		$Environment.visible = false
		$Lights.visible = false
		difficulty_thingy.copy_pending = false
		difficulty_thingy.copy_status_changed.emit(false)
	

func global_copy_changed(copying: bool):
	if copying:
		$Copy.toggled.disconnect(copy_button_toggled)
		$Copy.button_pressed = false
		$Copy.toggled.connect(copy_button_toggled)
		$Paste.visible = true
		$Notes.visible = false
		$Environment.visible = false
		$Lights.visible = false
	else:
		$Copy.toggled.disconnect(copy_button_toggled)
		$Copy.button_pressed = false
		$Copy.toggled.connect(copy_button_toggled)
		$Paste.visible = false
		$Notes.visible = false
		$Environment.visible = false
		$Lights.visible = false
