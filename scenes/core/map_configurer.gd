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
	
	get_tree().root.call_deferred("add_child", editor)
	call_deferred("queue_free")
	
func _ready() -> void:
	load_data()
	play_preview_button.pressed.connect(_on_play_preview_pressed)
func load_data():
	song_name_edit.text = map_data_manager.get_property(&"song_name")
	song_subname_edit.text = map_data_manager.get_property(&"song_subname")
	song_author_edit.text = map_data_manager.get_property(&"song_author_name")
	map_author_edit.text = map_data_manager.get_property(&"level_author_name")
	cover_display.texture = ImageTexture.create_from_image(Image.load_from_file($MapDataManager.path + map_data_manager.get_property(&"cover_image_filename")))
	cover_filename_edit.text = map_data_manager.get_property(&"cover_image_filename")
	song_filename_edit.text = map_data_manager.get_property(&"song_filename")
	song_bpm_edit.value = map_data_manager.get_property(&"beats_per_minute")
	song_preview_start_edit.value = map_data_manager.get_property(&"preview_start")
	song_preview_duration_edit.value = map_data_manager.get_property(&"preview_duration")


func _on_song_name_edit_text_changed(new_text: String) -> void:
	$MapDataManager.update_property(&"song_name", new_text)

func _on_play_preview_pressed():
	preview_audio_stream.volume_db = -80
	var audio_fade = get_tree().create_tween().set_parallel(false)
	preview_audio_stream.stream = AudioStreamOggVorbis.load_from_file($MapDataManager.path + map_data_manager.get_property(&"song_filename"))
	preview_audio_stream.play(map_data_manager.get_property(&"preview_start"))
	preview_timer.start(map_data_manager.get_property(&"preview_duration") - 0.5)
	audio_fade.tween_property(preview_audio_stream, "volume_db", 0, 0.5)
	await preview_timer.timeout
	audio_fade = get_tree().create_tween()
	audio_fade.tween_property(preview_audio_stream, "volume_db", -80, 0.5)
	await audio_fade.finished
	preview_audio_stream.stop()
	

