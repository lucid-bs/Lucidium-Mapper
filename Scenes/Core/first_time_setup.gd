extends Control

const MAIN_MENU = preload("res://Scenes/Core/main_menu.tscn")

var config = ConfigFile.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var install_detected = false
	
	var library_folders : FileAccess
	if OS.get_name() == "Windows":
		var dir = DirAccess.open("C:/Program Files (x86)/Steam/steamapps/common/Beat Saber/Beat Saber_Data")
		if dir:
			$DirectoryManager/HBoxContainer/LineEdit.text = "C:/Program Files (x86)/Steam/steamapps/common/Beat Saber/Beat Saber_Data"
			install_detected = true
		else:
			library_folders = FileAccess.open("C:/Program Files (x86)/Steam/steamapps/libraryfolders.vdf", FileAccess.READ)
	else:
		var dir = DirAccess.open(OS.get_environment("HOME") + "/.steam/steam/steamapps/common/Beat Saber/Beat Saber_Data")
		if dir:
			$DirectoryManager/HBoxContainer/LineEdit.text = OS.get_environment("HOME") + "/.steam/steam/steamapps/common/Beat Saber/Beat Saber_Data"
			install_detected = true
		else:
			library_folders = FileAccess.open(OS.get_environment("HOME") + "/.steam/steam/steamapps/libraryfolders.vdf", FileAccess.READ)
	
	if install_detected:
		pass
	else:
		var regex_instance = RegEx.new()
		var library_path_regex
		
		regex_instance.compile("\\s\"(?:\\d|path)\"\\s+\"(.+)\"")
		library_path_regex = regex_instance.search_all(library_folders.get_as_text() if library_folders != null else "")
		
		var directories = []
		for i in library_path_regex:
			directories.append(i.strings[1])
		
		for i in directories:
			var dir = DirAccess.open(i + "/steamapps/common/Beat Saber/Beat Saber_Data")
			if dir:
				$DirectoryManager/HBoxContainer/LineEdit.text = i + "/steamapps/common/Beat Saber/Beat Saber_Data"

func _on_file_dialog_dir_selected(dir: String) -> void:
	print(dir)
	$DirectoryManager/HBoxContainer/LineEdit.text = dir
	


func _on_button_pressed() -> void:
	config.set_value("Version", "ConfigVersion", 1)
	config.set_value("EditorGrid", "UsingBeatwallsSchema", false)
	config.set_value("FileSystem", "InstallDir", $DirectoryManager/HBoxContainer/LineEdit.text)
	config.save("user://settings.cfg")
	

	get_tree().change_scene_to_packed(MAIN_MENU)


func _on_use_appdata_button_pressed() -> void:
	$DirectoryManager/HBoxContainer/LineEdit.text = "user://maps/"


func _on_open_file_manager_button_pressed() -> void:
	$FileDialog.show()
