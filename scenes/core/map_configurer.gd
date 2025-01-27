extends Control

@export var map_data_manager : MapDataManager 

@export var song_name_edit : LineEdit
@export var song_subname_edit : LineEdit
@export var song_author_edit : LineEdit
@export var map_author_edit : LineEdit

@export var cover_display : TextureRect
@export var cover_filename_edit : LineEdit

@export var song_filename_edit : LineEdit
@export var song_bpm_edit : SpinBox
@export var song_preview_start_edit : SpinBox
@export var song_preview_duration_edit : SpinBox

@export var play_preview_button : Button
@export var preview_audio_stream : AudioStreamPlayer
@export var preview_timer : Timer

func _on_button_pressed() -> void:
	
	var editor = preload("res://scenes/core/editor.tscn").instantiate()
	
	editor.difficulty_beatmap = $DifficultyThingy.current_difficulty.difficulty_object
	# I have NO IDEA why the editor beatmap just... persists. 
	# Regardless, if we don't do the below, bad, BAD things will happen when we exit one map and open another.
	editor.beatmap = Beatmap.new()
	
	editor.map_path = $MapDataManager.path
	editor.audio_stream = AudioStreamOggVorbis.load_from_file($MapDataManager.path + map_data_manager.get_property(&"song_filename"))
	editor.current_bpm = map_data_manager.get_property(&"beats_per_minute")
	get_tree().root.call_deferred("add_child", editor)
	call_deferred_thread_group("queue_free")
	
func _ready() -> void:
	$DifficultyThingy/HBoxContainer/EnterEditorButton.disabled = true
	load_data()
	play_preview_button.pressed.connect(_on_play_preview_pressed)
	
	if randi_range(0, 4) == 3:
		$InfoDatThingy/MarginContainer/VBoxContainer/PanelContainer8/VBoxContainer/Label.text = "Waiting For Godot? More like Waiting for Waveform, ha!"
	else:
		$InfoDatThingy/MarginContainer/VBoxContainer/PanelContainer8/VBoxContainer/Label.text = "A Waveform will go here. Eventually. One day."
	
func load_data():
	song_name_edit.text = map_data_manager.get_property("song_name")
	song_subname_edit.text = map_data_manager.get_property("song_subname")
	song_author_edit.text = map_data_manager.get_property("song_author_name")
	map_author_edit.text = map_data_manager.get_property("level_author_name")
	cover_display.texture = ImageTexture.create_from_image(Image.load_from_file($MapDataManager.path + map_data_manager.get_property(&"cover_image_filename")))
	cover_filename_edit.text = map_data_manager.get_property(&"cover_image_filename")
	song_filename_edit.text = map_data_manager.get_property(&"song_filename")
	song_bpm_edit.value = map_data_manager.get_property(&"beats_per_minute")
	song_preview_start_edit.value = map_data_manager.get_property(&"preview_start")
	song_preview_duration_edit.value = map_data_manager.get_property(&"preview_duration")

	$"DifficultyThingy/VBoxContainer/E+".difficulty_object = map_data_manager.get_difficulty(&"Standard", &"ExpertPlus")
	$"DifficultyThingy/VBoxContainer/Ex".difficulty_object = map_data_manager.get_difficulty(&"Standard", &"Expert")
	$"DifficultyThingy/VBoxContainer/H".difficulty_object = map_data_manager.get_difficulty(&"Standard", &"Hard")
	$"DifficultyThingy/VBoxContainer/N".difficulty_object = map_data_manager.get_difficulty(&"Standard", &"Normal")
	$"DifficultyThingy/VBoxContainer/E".difficulty_object = map_data_manager.get_difficulty(&"Standard", &"Easy")
	

func _on_play_preview_pressed():
	preview_audio_stream.volume_db = -80
	var audio_fade = get_tree().create_tween().set_parallel(false)
	preview_audio_stream.stream = AudioStreamOggVorbis.load_from_file($MapDataManager.path + map_data_manager.get_property(&"song_filename"))
	preview_audio_stream.play(map_data_manager.get_property(&"preview_start"))
	preview_timer.start(map_data_manager.get_property(&"preview_duration") -2)
	audio_fade.tween_property(preview_audio_stream, "volume_db", 0, 0.5)
	await preview_timer.timeout
	audio_fade = get_tree().create_tween()
	audio_fade.tween_property(preview_audio_stream, "volume_db", -80, 2)
	await audio_fade.finished
	preview_audio_stream.stop()



func _on_difficulty_thingy_difficulty_changed(new_difficulty: DifficultyThingyDiff) -> void:
	$DifficultyThingy/HBoxContainer/EnterEditorButton.disabled = false


func _on_exit_pressed() -> void:
	var mm = load("res://scenes/core/main_menu.tscn")
	get_tree().change_scene_to_packed(mm)
	# For some reason, Godot isn't destroying on change scene to packed.
	call_deferred_thread_group("queue_free")
