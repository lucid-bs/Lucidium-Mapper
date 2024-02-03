extends Control

@export var map_data_manager : MapDataManager 

func _on_button_pressed() -> void:
	
	var editor = preload("res://Scenes/Core/editor.tscn").instantiate()
	
	get_tree().root.call_deferred("add_child", editor)
	call_deferred("queue_free")
	
func _ready() -> void:
	load_data()
func load_data():
	$InfoDatThingy/MarginContainer/VBoxContainer/PanelContainer/HBoxContainer/SongNameEdit.text = map_data_manager.get_property(&"song_name")
	$InfoDatThingy/MarginContainer/VBoxContainer/PanelContainer4/HBoxContainer/SongSubnameEdit.text = map_data_manager.get_property(&"song_subname")
	$InfoDatThingy/MarginContainer/VBoxContainer/PanelContainer2/HBoxContainer/SongAuthorEdit.text = map_data_manager.get_property(&"song_author_name")
	$InfoDatThingy/MarginContainer/VBoxContainer/PanelContainer3/HBoxContainer/MapAuthorEdit.text = map_data_manager.get_property(&"level_author_name")
	$InfoDatThingy/MarginContainer/VBoxContainer/PanelContainer6/HBoxContainer/CoverFilenameEdit.text = map_data_manager.get_property(&"cover_image_filename")
	$InfoDatThingy/MarginContainer/VBoxContainer/PanelContainer5/HBoxContainer/SongFilenameEdit.text = map_data_manager.get_property(&"song_filename")
	$InfoDatThingy/MarginContainer/VBoxContainer/PanelContainer7/HBoxContainer/BPMSpinBox.value = map_data_manager.get_property(&"beats_per_minute")
	$InfoDatThingy/MarginContainer/VBoxContainer/PanelContainer8/HBoxContainer2/PreviewStartContainer/PreviewStartSpinBox.value = map_data_manager.get_property(&"preview_start")
	$InfoDatThingy/MarginContainer/VBoxContainer/PanelContainer8/HBoxContainer2/PreviewDurationContainer/PreviewDurationSpinBox.value = map_data_manager.get_property(&"preview_duration")
func _on_song_name_edit_text_changed(new_text: String) -> void:
	$MapDataManager.update_property(&"song_name", new_text)
