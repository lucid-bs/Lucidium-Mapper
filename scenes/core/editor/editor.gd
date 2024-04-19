extends Node

signal setting_updated(setting : String, old_value, new_value)

var config = ConfigFile.new()

func _ready() -> void:
	config = config.load("user://settings.cfg")

func get_setting(setting : String):
	pass

func update_setting(setting : String, new_value):
	print(new_value)
