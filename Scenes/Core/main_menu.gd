extends Control

var config = ConfigFile.new()

const MM_MAP = preload("res://Scenes/Core/Assets/mm_Map.tscn")

const MAP_CONFIGURER = preload("res://Scenes/Core/map_configurer.tscn")

func _ready() -> void:
	
	$ScrollContainer/VBoxContainer/Panel.queue_free()
	
	
	var err = config.load("user://settings.cfg")
	print(config.get_value("FileSystem", "InstallDir") + "/CustomWIPLevels")
	var map_directory = DirAccess.get_directories_at(config.get_value("FileSystem", "InstallDir") + "/CustomWIPLevels")
	print(map_directory)
	for i in map_directory:
		print(config.get_value("FileSystem", "InstallDir") + "/CustomWIPLevels/" + i + "/Info.dat")
		if !FileAccess.file_exists(config.get_value("FileSystem", "InstallDir") + "/CustomWIPLevels/" + i + "/Info.dat"):
			print("Not Found")
		else:
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
			
			

func _configure_map(directory: String):
	get_tree().change_scene_to_packed(MAP_CONFIGURER)
