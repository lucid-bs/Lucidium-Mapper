class_name DifficultyThingyDiff
extends PanelContainer

@export var enabled : bool = false

@export var selected : bool = false

@export var difficulty_thingy : DifficultyThingy

@export var difficulty_object : DifficultyBeatmap:
	set(value):
		if value == null:
			enabled = false
			$MarginContainer/HBoxContainer/CheckButton.button_pressed = false
		else:
			enabled = true
			$MarginContainer/HBoxContainer/CheckButton.button_pressed = true
		difficulty_object = value
		

func _ready() -> void:
	$MarginContainer/HBoxContainer/CheckButton.toggled.connect(enabled_check_button_changed)
	if !difficulty_object:
		difficulty_object = DifficultyBeatmap.new()
	$SelectionButton.show()
	selected = false
	theme_type_variation = "DarkPanelContainer"
	$SelectionButton.pressed.connect(selection_button_pressed)
	difficulty_thingy.difficulty_changed.connect(new_difficulty_selected)

func selection_button_pressed():
	$SelectionButton.hide()
	theme_type_variation = "LightPanelContainer"
	selected = true
	difficulty_thingy.difficulty_changed.emit(self)
	difficulty_thingy.current_difficulty = self
	if difficulty_object:
		difficulty_thingy.update_controls()

func new_difficulty_selected(difficulty : DifficultyThingyDiff):
	if difficulty != self:
		$SelectionButton.show()
		theme_type_variation = "DarkPanelContainer"
		selected = false
	
func enabled_check_button_changed(new_value : bool):
	enabled = new_value
