extends Node
class_name SettingsManager;

@onready var settings: Persistence = $Settings;

func _ready():
	_load_data();

func _load_data():
	var settings_dict = settings.data as Dictionary;
	
	for key in settings_dict:
		match key:
			'fullscreen':
				get_window().mode = settings_dict[key] as Window.Mode;
				break;
			'resolution':
				_set_res(SettingsManager.string_to_vector2i(settings_dict[key]));
				break;

func _set_res(size: Vector2i):
	get_tree().root.size = size;
	get_window().size = size;

static func string_to_vector2i(string := "") -> Vector2i:
	if string:
		var new_string: String = string
		new_string = new_string.erase(0, 1)
		new_string = new_string.erase(new_string.length() - 1, 1)
		var array: Array = new_string.split(", ")

		return Vector2i(int(array[0]), int(array[1]))

	return Vector2i.ZERO

static func string_to_vector3(string := "") -> Vector3:
	if string:
		var new_string: String = string
		new_string = new_string.erase(0, 1)
		new_string = new_string.erase(new_string.length() - 1, 1)
		var array: Array = new_string.split(", ")

		return Vector3(float(array[0]), float(array[1]), float(array[2]))

	return Vector3.ZERO;
	