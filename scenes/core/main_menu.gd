extends Control

var config = ConfigFile.new()

const MM_MAP = preload("res://scenes/core/assets/mm_Map.tscn")

const MAP_CONFIGURER = preload("res://scenes/core/map_configurer.tscn")

var loaded_maps : float = 0

const MM_MESSAGE_BOARD_PANEL = preload("res://scenes/core/assets/mm_message_board_panel.tscn")

var folders := ["CustomWIPLevels", "CustomLevels"]


func _ready() -> void:
	
	$Popup.hide()
	$TabBar/RemoveCustom.hide()
	$AdditionalFolderDeleteConfirm.hide()
	$ScrollContainer/VBoxContainer/Panel.queue_free()
	var err = config.load("user://settings.cfg")
	print(config.get_value("FileSystem", "InstallDir") + "/CustomWIPLevels")
	
	scan_for_maps(config.get_value("FileSystem", "InstallDir"))
	
	var additional_folders = config.get_value("FileSystem", "AdditionalFolders", [])
	folders.append_array(additional_folders)
	if folders.size() > 2:
		for i in range(1, folders.size() - 1):
			$TabBar.add_tab(folders[i + 1])
			$TabBar.move_tab($TabBar.tab_count - 1, $TabBar.tab_count - 2)
			
	
	if config.get_value("Networking", "Online", false):
		var http_request = HTTPRequest.new()
		add_child(http_request)
		http_request.request_completed.connect(self._http_request_completed)

		var error = http_request.request("https://gitlab.com/lucid-bs/lucid-message-board/-/raw/main/messages.json")
		if error != OK:
			push_error("An error occurred in the HTTP request.")

	
	if randi_range(0, 3) == 2:
		$"TabContainer/New Map/Panel/MarginContainer/VBoxContainer/FailsafeNoMapMaking".text = "That's how it's supposed to be right now. The priority is to get everything accurate to Beat Saber, and saving Map Data is lower on my Priorities list. If you need an [b]actual editor[/b], [url=https://cm.topc.at/dl]have you heard about our lord and savior, ChroMapper Chan?[/url] "
	else:
		$"TabContainer/New Map/Panel/MarginContainer/VBoxContainer/FailsafeNoMapMaking".text = "That's how it's supposed to be right now. The priority is to get everything accurate to Beat Saber, and saving Map Data is lower on my Priorities list. If you need an [b]actual editor[/b], [url=https://cm.topc.at/dl]download ChroMapper.[/url] "

# Called when the HTTP request is completed.
func _http_request_completed(result, response_code, headers, body):
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Something went wrong while trying to load the message board. Check if the domain for Gitlab is blocked.")

	var messages_json = JSON.parse_string(body.get_string_from_utf8())
	
	if messages_json.has("stickied_messages"):
		for i in messages_json["stickied_messages"]:
			var new_message : MessageBoardPanel = MM_MESSAGE_BOARD_PANEL.instantiate()
			new_message.message = i["message"]
			new_message.tooltip_text = "Message Time: " + Time.get_datetime_string_from_unix_time(i["time"])
			if i["tooltip"]:
				new_message.tooltip_text += " Custom Tooltip: " + i["tooltip"]
			new_message.sticky = true
			$"TabContainer/Main Menu/ScrollContainer/VBoxContainer/ScrollContainer/VBoxContainer".add_child(new_message)
	
	for i in messages_json["messages"]:
		var new_message : MessageBoardPanel = MM_MESSAGE_BOARD_PANEL.instantiate()
		new_message.message = i["message"]
		new_message.tooltip_text = "Message Time: " + Time.get_datetime_string_from_unix_time(i["time"])
		if i["tooltip"]:
			new_message.tooltip_text += " Custom Tooltip: " + i["tooltip"]
		new_message.sticky = false
		$"TabContainer/Main Menu/ScrollContainer/VBoxContainer/ScrollContainer/VBoxContainer".add_child(new_message)
		
		
	


func _configure_map(directory: String):
	var map_config = MAP_CONFIGURER.instantiate()
	map_config.map_data_manager.path = directory
	
	get_tree().root.call_deferred("add_child", map_config)
	call_deferred("queue_free")
	
func scan_for_maps(directory : String, subfolder : String = "CustomWIPLevels"):
	var map_directory = DirAccess.get_directories_at(directory + "/" + subfolder)
	print(map_directory)
	for i in map_directory:
		print(config.get_value("FileSystem", "InstallDir") + "/" + subfolder + "/" + i + "/Info.dat")
		if !FileAccess.file_exists(config.get_value("FileSystem", "InstallDir") + "/" + subfolder + "/" + i + "/Info.dat"):
			print("Not Found")
		else:
			loaded_maps += 1
			var infodat = FileAccess.open(config.get_value("FileSystem", "InstallDir") + "/" + subfolder + "/" + i + "/Info.dat", FileAccess.READ)
			var data = JSON.parse_string(infodat.get_as_text())
			var map_button = MM_MAP.instantiate()
			map_button.Title = data["_songName"]
			map_button.Subtitle = data["_songSubName"]
			map_button.Author = data["_songAuthorName"]
			map_button.Mapper = data["_levelAuthorName"]
			map_button.map_directory = config.get_value("FileSystem", "InstallDir") + "/" + subfolder + "/" + i + "/"
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
	print(config.get_value("FileSystem", "InstallDir") + "/CustomWIPLevels/")
	
	scan_for_maps(config.get_value("FileSystem", "InstallDir"))


func _on_reconfigure_pressed() -> void:
	var FIRST_TIME_SETUP = load("res://scenes/core/first_time_setup.tscn")
	var first_time_setup = FIRST_TIME_SETUP.instantiate()
	
	get_tree().root.call_deferred("add_child", first_time_setup)
	call_deferred("queue_free")


func _on_failsafe_no_map_making_meta_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta))


func folder_tab_changed(tab : int):
	for i in $ScrollContainer/VBoxContainer.get_children():
		i.queue_free()
	print(folders)
	print(tab)
	if tab > folders.size() - 1:
		$Popup.show()
		$Popup/Panel/MarginContainer/VBoxContainer/HBoxContainer/LineEdit.text = ""
		$Popup/Panel/MarginContainer/VBoxContainer/HBoxContainer/LineEdit.grab_focus()
		return
	elif tab > 1:
		$TabBar/RemoveCustom.show()
	else:
		$TabBar/RemoveCustom.hide()
	scan_for_maps(config.get_value("FileSystem", "InstallDir"), folders[tab])

func _on_folder_popup_confirm_pressed() -> void:
	folders.append($Popup/Panel/MarginContainer/VBoxContainer/HBoxContainer/LineEdit.text)
	$TabBar.add_tab($Popup/Panel/MarginContainer/VBoxContainer/HBoxContainer/LineEdit.text)
	$TabBar.move_tab($TabBar.tab_count - 1, $TabBar.tab_count - 2)
	$TabBar.current_tab = $TabBar.tab_count - 2
	var additional_folders = config.get_value("FileSystem", "AdditionalFolders", [])
	additional_folders.append($Popup/Panel/MarginContainer/VBoxContainer/HBoxContainer/LineEdit.text)
	config.set_value("FileSystem", "AdditionalFolders", additional_folders)
	print_debug(config.get_value("FileSystem", "InstallDir") + "/" + folders[$TabBar.current_tab])
	DirAccess.make_dir_recursive_absolute(config.get_value("FileSystem", "InstallDir") + "/" +  folders[$TabBar.current_tab])
	scan_for_maps(config.get_value("FileSystem", "InstallDir"), $Popup/Panel/MarginContainer/VBoxContainer/HBoxContainer/LineEdit.text)
	config.save("user://settings.cfg")



func _on_confirm_pressed() -> void:
	var additional_folders = config.get_value("FileSystem", "AdditionalFolders", [])
	var folder_name = folders[$TabBar.current_tab]
	additional_folders.erase(folders[$TabBar.current_tab])
	$TabBar.remove_tab(folders.find(folders[$TabBar.current_tab]))
	folders.erase(folder_name)
	$TabBar.current_tab -= 1
	config.set_value("FileSystem", "AdditionalFolders", additional_folders)
	scan_for_maps(config.get_value("FileSystem", "InstallDir"), folders[$TabBar.current_tab])
	config.save("user://settings.cfg")


func _on_remove_custom_pressed() -> void:
	$AdditionalFolderDeleteConfirm.show()
	$AdditionalFolderDeleteConfirm/Panel/MarginContainer/VBoxContainer/HBoxContainer2/Confirm.grab_focus()
