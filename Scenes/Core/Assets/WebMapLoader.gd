extends Control

var config = ConfigFile.new()

# Beat Saver API - https://api.beatsaver.com/maps/id/

var resourceLocator : String

signal thingyUpdated

var downloadURL : String


func _ready():
	var err = config.load("user://settings.cfg")
	
	$HTTPRequest.request_completed.connect(_on_request_completed)
	

func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	if !json:
		# Assume Zip File was downloaded
		thingyUpdated.emit()
		print("debug")
		return
	print(json["versions"][0]["downloadURL"])
	downloadURL = json["versions"][0]["downloadURL"]
	thingyUpdated.emit()
	
	

func _on_button_pressed() -> void:
	resourceLocator = $VBoxContainer/Input/LineEdit.text 
	if "https://" in resourceLocator:
		downloadURL = resourceLocator
		pass
	else:
		# Assume code is a BeatSaver code
		if resourceLocator == "":
			resourceLocator = "368cf"
		var beatSaverAPIEndpoint = "https://api.beatsaver.com/maps/id/" + resourceLocator
		$HTTPRequest.request(beatSaverAPIEndpoint)
		await thingyUpdated
	if $VBoxContainer/FILESYSTEM/TabBar.current_tab == 0:
		$HTTPRequest.download_file = config.get_value("FileSystem", "InstallDir") + "/CustomWIPLevels/" + "lucid.zip"
	else:
		$HTTPRequest.download_file = "user://lucid.zip"
	
	$HTTPRequest.request(downloadURL)
	await thingyUpdated
	var reader = ZIPReader.new()
	var err := reader.open($HTTPRequest.download_file)
	if err != OK:
		print_debug("ERROR - FILE INVALID")
	else:
		print_debug("FILE VALID")
		var info = JSON.parse_string(reader.read_file("Info.dat").get_string_from_ascii())
		print(info)
		
