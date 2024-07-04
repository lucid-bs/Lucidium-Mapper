extends Control

@export var next_scene : String

var progress : Array
# Called when the node enters the scene tree for the first time.
func _ready():
	ResourceLoader.load_threaded_request(next_scene)

func switch_scenes_manually(scene : PackedScene):
	# This is like autoloading the scene, only
	# it happens after already loading the main scene.
	get_tree().root.call_deferred("add_child", scene.instantiate())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	ResourceLoader.load_threaded_get_status(next_scene, progress)
	$TextureProgressBar.value = remap(progress[0], 0, 1, 0, 100)
	if progress[0] == 1:
		var new_scene = ResourceLoader.load_threaded_get(next_scene)
		switch_scenes_manually(new_scene)
		
