extends Node
class_name SettingsManager;

@onready var settings: Persistence = $Settings;
@onready var timers: TimerContainer = get_node("%Timers");

var last_window_size = Vector2i();

var TIMER_autosave = "";
var resize_timer = null;

func _ready():
	_load_data();
	if timers != null:
		timers.timer_done.connect(_on_timer_done);

	var autosave_time = settings.data['autosave_time'] if settings.data.has('autosave_time') else 0;
	if autosave_time > 0 && timers != null:
		TIMER_autosave = timers.create_timer(autosave_time, "Autosave Timer");
	else:
		TIMER_autosave = "";

func _process(_delta):
	var window_size = DisplayServer.window_get_size();

	if window_size != last_window_size:
		last_window_size = window_size;
		_on_resize();

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
			'window_size':
				_set_win_size(SettingsManager.string_to_vector2i(str(settings_dict[key])));
				continue;
#			'ui_scaling':
#				_set_ui_scaling(settings_dict[key]);
#				continue;
			'pan_speed':
				_set_cam_pan_speed(settings_dict[key]);
				continue;
			'zoom_speed':
				_set_cam_zoom_speed(settings_dict[key]);
				continue;

func _set_res(size: Vector2i):
	get_tree().root.size = size;

func _set_win_size(size: Vector2i):
	get_window().size = size;

func _set_ui_scaling(value: int):
	get_tree().root.content_scale_mode = value as Window.ContentScaleMode;

func _set_cam_pan_speed(value: float):
	var cam_base = get_node("/root/Root/CAMERA_BASE");
	if cam_base != null:
		cam_base.camera_pan_speed = value;

func _set_cam_zoom_speed(value: float):
	var cam_base = get_node("/root/Root/CAMERA_BASE");
	if cam_base != null:
		cam_base.camera_zoom_speed = value;

func reset_autosave_timer(new_time: int):
	if TIMER_autosave != '' && timers != null:
		timers.delete_timer(TIMER_autosave);

	if new_time > 0 && timers != null:
		TIMER_autosave = timers.create_timer(new_time, "Autosave Timer");
	else:
		TIMER_autosave = "";

func _on_resize():
	settings.data['window_size'] = str(last_window_size);
	settings.save();

func _on_timer_done(id: String):
	if id == TIMER_autosave:
		var autosave_time = settings.data['autosave_time'] if settings.data.has('autosave_time') else 0;
		if autosave_time > 0 && timers != null:
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
	
