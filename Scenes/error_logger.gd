extends VBoxContainer


func log_message(message: String):
	var printmsg = Label.new()
	printmsg.text = Time.get_datetime_string_from_system() + " - " + message
	add_child(printmsg)
	
	
