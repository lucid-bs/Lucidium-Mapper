extends Control

const MAIN_MENU = preload("res://Scenes/Core/main_menu.tscn")

var config = ConfigFile.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var install_detected = false
	if OS.get_name() == "Windows":
		var dir = DirAccess.open("C:/Program Files (x86)/Steam/steamapps/common/Beat Saber/Beat Saber_Data")
		if dir:
			config.set_value("FileSystem", "InstallDir", "C:/Program Files (x86)/Steam/steamapps/common/Beat Saber/Beat Saber_Data")
			install_detected = true
			config.save("user://settings.cfg")
		
			
	else:
		var dir = DirAccess.open("~/.steam/steam/steamapps/common/Beat Saber/Beat Saber_Data")
		if dir:
			config.set_value("FileSystem", "InstallDir", "~/.steam/steam/steamapps/common/Beat Saber/Beat Saber_Data")
			config.save("user://settings.cfg")
			install_detected = true
	
	if install_detected:
		get_tree().change_scene_to_packed(MAIN_MENU)



func _on_file_dialog_dir_selected(dir: String) -> void:
	print(dir)
	config.set_value("FileSystem", "InstallDir", dir)
	config.save("user://settings.cfg")
	
	get_tree().change_scene_to_packed(MAIN_MENU)
	
