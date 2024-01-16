extends Control

@export var map_data_manager : MapDataManager 



func _on_button_pressed() -> void:
	
	
	var editor = preload("res://Scenes/Core/editor.tscn").instantiate()
	
	get_tree().root.call_deferred("add_child", editor)
	call_deferred("queue_free")
