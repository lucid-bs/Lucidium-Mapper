extends CodeEdit


func get_class_instance(name: String):    
	var classes = ProjectSettings.get_global_class_list()
	for element in classes:        
		if element["class"] == name:            
			return load(element["path"]).new()    
	push_error("Class \"" + name + "\" could not be found")    
	return null
	
func _ready():
	# Iterate over all available utility functions provided by Godot's scripting API.
	var utilities
	var e = Block.new()
	e = e.get_class()
	print(ClassDB.get_class_list())
	if get_class_instance("Block"):
		utilities = get_class_instance("Block")
		utilities = utilities.get_property_list()
	
	add_code_completion_option(CodeEdit.KIND_FUNCTION, "e", "test")
	update_code_completion_options(true)

	for i in utilities:
		print("%s" % [i])
		


func _on_code_completion_requested() -> void:
	var cc
	var cci
	if get_class_instance("Block"):
		cc = get_class_instance("Block")
		CodeEdit
		cci = cc.get_property_list()
		get_property_list()
		for i in cci:
			add_code_completion_option(CodeEdit.KIND_MEMBER, i["name"], i["name"])
		cci = cc.get_method_list()
		for i in cci:
			add_code_completion_option(CodeEdit.KIND_FUNCTION, i["name"], i["name"] + "()")
		
	
	update_code_completion_options(true)
