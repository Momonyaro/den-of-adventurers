extends Node
class_name SettingsManager;

@onready var settings: Persistence = $Settings;
@onready var timers: TimerContainer = get_node("%Timers");

var TIMER_autosave = "";

func _ready():
	_load_data();
	timers.timer_done.connect(_on_timer_done);

	var autosave_time = settings.data['autosave_time'] if settings.data.has('autosave_time') else 0;
	if autosave_time > 0:
		TIMER_autosave = timers.create_timer(autosave_time, "Autosave Timer");
	else:
		TIMER_autosave = "";

func _load_data():
	var settings_dict = settings.data as Dictionary;
	
	for key in settings_dict.keys():
		match key:
			'fullscreen':
				get_window().mode = settings_dict[key] as Window.Mode;
				continue;
			'resolution':
				_set_res(SettingsManager.string_to_vector2i(str(settings_dict[key])));
				continue;
			'ui_scaling':
				_set_ui_scaling((settings_dict[key]));
				continue;

func _set_res(size: Vector2i):
	get_tree().root.size = size;
	get_window().size = size;

func _set_ui_scaling(value: int):
	get_tree().root.content_scale_mode = value as Window.ContentScaleMode;

func reset_autosave_timer(new_time: int):
	if TIMER_autosave != '':
		timers.delete_timer(TIMER_autosave);

	if new_time > 0:
		TIMER_autosave = timers.create_timer(new_time, "Autosave Timer");
	else:
		TIMER_autosave = "";


func _on_timer_done(id: String):
	if id == TIMER_autosave:
		var autosave_time = settings.data['autosave_time'] if settings.data.has('autosave_time') else 0;
		if autosave_time > 0:
			TIMER_autosave = timers.create_timer(autosave_time, "Autosave Timer");
			get_node("/root/Root/DataStore")._save_game();
		else:
			TIMER_autosave = "";

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
	