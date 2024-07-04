class_name DifficultyThingyDiff
extends PanelContainer

@export var selected : bool = false

@export var difficulty_thingy : DifficultyThingy

@export var difficulty_object : DifficultyBeatmap


func _ready() -> void:
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
	
