extends VBoxContainer


func log_message(message: String):
	var printmsg = Label.new()
	printmsg.text = Time.get_datetime_string_from_system() + " - " + message
	printmsg.add_theme_font_size_override("font_size", 13)
	add_child(printmsg)
	
	
