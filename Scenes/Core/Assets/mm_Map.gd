extends Panel


signal Map_Selected(directory : String)
@export var Title : String
@export var Subtitle : String

@export var Author : String
@export var Mapper : String

@export var Map_Image : String

@export var map_directory : String

func _ready() -> void:
	$Title/Title.text = Title
	
	if Subtitle == "":
		$Title/Subtitle.queue_free()
	else:
		$Title/Subtitle.text = Subtitle
	
	$Author/Author.text = Author
	$Author/Mapper.text = Mapper
	
	$Directory.text = map_directory
	
	var image = Image.load_from_file(map_directory + "/" + Map_Image)
	var texture = ImageTexture.create_from_image(image)
	$TextureRect.texture = texture
	
	
	


func _on_selection_button_pressed() -> void:
	Map_Selected.emit(map_directory)
