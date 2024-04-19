extends MenuButton

func _ready() -> void:
	get_popup().id_pressed.connect(on_item_selected)
	
func on_item_selected(id):
	$"../../SettingsWindow".visible = true
