@tool
class_name SettingsTree
extends MarginContainer


@export var tabs : Dictionary:
	set(value):
		tabs = value
		
		
@export var active_node : Container

func _ready() -> void:
	update_tree()

func update_tree():
	var tree = $HSplitContainer/Tree
	var root = tree.create_item()
	tree.hide_root = true
	for i in tabs:
		var child1 = tree.create_item(root)
		child1.set_selectable(0, false)
		child1.set_text(0, i.capitalize())
		for y in tabs[i]:
			var child2 = tree.create_item(child1)
			child2.set_text(0, y.capitalize())
			child2.set_meta("node_path", tabs[i][y].node_path)
			get_node(tabs[i][y].node_path).hide()
	active_node.show()
			


func _on_tree_item_selected() -> void:
	var tree = $HSplitContainer/Tree
	active_node.hide()
	active_node = get_node(tree.get_selected().get_meta("node_path")) 
	active_node.show()
	
