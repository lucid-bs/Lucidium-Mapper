extends Control

var config = ConfigFile.new()




func _ready() -> void:
	var err = config.load("user://settings.cfg")
	var map_directory = DirAccess.get_directories_at(config.get_value("FileSystem", "InstallDir") + "/CustomWIPLevels")
	print(map_directory)
	
