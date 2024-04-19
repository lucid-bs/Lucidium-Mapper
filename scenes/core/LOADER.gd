extends Node

var config = ConfigFile.new()

var err = config.load("user://settings.cfg")

## Defines a Editor version that prompts a settings update if the config is older
@export var min_config_version : int = 1

func _ready():
	DisplayServer.window_set_min_size(Vector2i(1280, 720))
	if err != OK:
		get_tree().change_scene_to_file("res://scenes/core/first_time_setup.tscn")
	else:
		var config_version = config.get_value("Version", "ConfigVersion", 0)

		if config_version >= min_config_version:
			get_tree().change_scene_to_file("res://scenes/core/main_menu.tscn")
		else:
			get_tree().change_scene_to_file("res://scenes/core/first_time_setup.tscn")
		
