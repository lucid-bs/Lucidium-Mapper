extends Window


func _on_close_requested() -> void:
	hide()

func _on_visibility_changed() -> void:
	if visible:
		$Panel/MarginContainer/VBoxContainer/HBoxContainer2/Confirm.disabled = true

func _on_back_pressed() -> void:
	hide()


func _on_line_edit_text_changed(new_text: String) -> void:
	if new_text != "":
		$Panel/MarginContainer/VBoxContainer/HBoxContainer2/Confirm.disabled = false
	else:
		$Panel/MarginContainer/VBoxContainer/HBoxContainer2/Confirm.disabled = true


func _on_confirm_pressed() -> void:
	hide()

func _on_line_edit_text_submitted(new_text: String) -> void:
	$Panel/MarginContainer/VBoxContainer/HBoxContainer2/Confirm.pressed.emit()
