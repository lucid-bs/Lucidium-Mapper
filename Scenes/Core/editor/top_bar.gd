extends Panel


@onready var tabs = [
	{
		"left_menu" = $"../HSplitContainer/HSplitContainer/LeftChartTabMargin",
		"right_menu" = $"../HSplitContainer/RightChartTabMargin",
		"enter" = func():
			$"../../WorldEnvironment".environment.glow_enabled = false
			$"../../Grid".show(),
		"exit" = func():
			$"../../WorldEnvironment".environment.glow_enabled = true
			$"../../Grid".hide(),
	},
	{},
	{},
]

func update_tabs():
	var tabs_minus_current = tabs.duplicate(true)
	tabs_minus_current.remove_at($TabBar.current_tab)
	for i in tabs_minus_current:
		if i.has("left_menu"):
			i["left_menu"].set_visible(false)
		if i.has("right_menu"):
			i["right_menu"].set_visible(false)
		if i.has("exit"):
			i["exit"].call()
	if tabs.size() - 1 >= $TabBar.current_tab:
		if tabs[$TabBar.current_tab].has("left_menu"):
			tabs[$TabBar.current_tab]["left_menu"].set_visible(true)
		if tabs[$TabBar.current_tab].has("right_menu"):
			tabs[$TabBar.current_tab]["right_menu"].set_visible(true)
		if tabs[$TabBar.current_tab].has("enter"):
			tabs[$TabBar.current_tab]["enter"].call()

func _on_tab_bar_tab_changed(tab: int) -> void:
	update_tabs()

func _ready() -> void:
	update_tabs()
