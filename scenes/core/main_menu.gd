extends Control

var config = ConfigFile.new()

const MM_MAP = preload("res://scenes/core/assets/mm_Map.tscn")

const MAP_CONFIGURER = preload("res://scenes/core/map_configurer.tscn")



var loaded_maps : float = 0

func _ready() -> void:
	
	$ScrollContainer/VBoxContainer/Panel.queue_free()
	var err = config.load("user://settings.cfg")
	print(config.get_value("FileSystem", "InstallDir") + "/CustomWIPLevels")
	
	scan_for_maps(config.get_value("FileSystem", "InstallDir"))
func _configure_map(directory: String):
	var map_config = MAP_CONFIGURER.instantiate()
	map_config.map_data_manager.path = directory
	
	get_tree().root.call_deferred("add_child", map_config)
	call_deferred("queue_free")
	
func scan_for_maps(directory : String):
	var map_directory = DirAccess.get_directories_at(directory + "/CustomWIPLevels")
	print(map_directory)
	for i in map_directory:
		print(config.get_value("FileSystem", "InstallDir") + "/CustomWIPLevels/" + i + "/Info.dat")
		if !FileAccess.file_exists(config.get_value("FileSystem", "InstallDir") + "/CustomWIPLevels/" + i + "/Info.dat"):
			print("Not Found")
		else:
			loaded_maps += 1
			var infodat = FileAccess.open(config.get_value("FileSystem", "InstallDir") + "/CustomWIPLevels/" + i + "/Info.dat", FileAccess.READ)
			var data = JSON.parse_string(infodat.get_as_text())
			var map_button = MM_MAP.instantiate()
			map_button.Title = data["_songName"]
			map_button.Subtitle = data["_songSubName"]
			map_button.Author = data["_songAuthorName"]
			map_button.Mapper = data["_levelAuthorName"]
			map_button.map_directory = config.get_value("FileSystem", "InstallDir") + "/CustomWIPLevels/" + i + "/"
			map_button.Map_Image = data["_coverImageFilename"]
			map_button.Map_Selected.connect(_configure_map)
			$ScrollContainer/VBoxContainer.add_child(map_button)
	if loaded_maps == 0:
		$ScrollContainer.hide()
		$HELP.show()
		$HELP/MarginContainer/VBoxContainer/d6.text = "A: Rescan '" + str(config.get_value("FileSystem", "InstallDir")) + "/CustomWIPLevels' for Maps"
	else:
		$ScrollContainer.show()
		$HELP.hide()
		



func _on_rescan_pressed() -> void:
	var err = config.load("user://settings.cfg")
	print(config.get_value("FileSystem", "InstallDir") + "/CustomWIPLevels")
	
	scan_for_maps(config.get_value("FileSystem", "InstallDir"))


func _on_reconfigure_pressed() -> void:
	var FIRST_TIME_SETUP = load("res://scenes/core/first_time_setup.tscn")
	var first_time_setup = FIRST_TIME_SETUP.instantiate()
	
	get_tree().root.call_deferred("add_child", first_time_setup)
	call_deferred("queue_free")


func _on_failsafe_no_map_making_meta_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta))
