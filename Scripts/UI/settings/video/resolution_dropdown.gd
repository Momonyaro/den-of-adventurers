extends Node

var _dropdown: Node = null;
var _last_mode = -1;
@onready var settings: Persistence = get_node("/root/Root/SettingsMngr/Settings");

func _ready():
	
	_dropdown = $dropdown;
		
	if OS.has_feature('web'):
		_dropdown._disabled = true;
		_dropdown.tooltip_text = "Not available in web version."
	else:
		_dropdown.new_current.connect(_on_new_value);
	
	var screen_size = DisplayServer.screen_get_size();
	var options = _get_options(screen_size.x, screen_size.y);
	
	for option in options:
		_dropdown.add_item(option[0], "", option[1]);
	
	var default = _get_current();
	_dropdown.set_active_no_event(default[0], default[1])

func _process(_delta):
	var _mode = get_window().mode;
	var is_fullscreen = _mode == Window.Mode.MODE_FULLSCREEN;
	if _mode != _last_mode:
		var default = _get_current();
		_dropdown.set_active_no_event(default[0], default[1]);
	
	_last_mode = _mode;


func _on_new_value(label: String, value: String, id: int):
	match id:
		540: _set_res(960, 540);
		720: _set_res(1280, 720);
		768: _set_res(1366, 768);
		900: _set_res(1600, 900);
		1080: _set_res(1920, 1080);
		1440: _set_res(2560, 1440);
		1800: _set_res(3200, 1800);
		2160: _set_res(3840, 2160);

func _get_current() -> Array:
	var data = settings.data;
	var current = SettingsManager.string_to_vector2i(str(data['resolution'])) if data.has('resolution') else get_window().size;
	var current_str = str(current.x, "x", current.y)
	return [current_str, current.y];

func _get_options(screen_w: int, screen_h: int) -> Array: # only 16:9 support for the moment at least.
	var resolutions = [];
	#if screen_w >= 960 && screen_h >= 540:   resolutions.push_back(["960x540",   540]); # web target? [DEPRECATED]
	if screen_w >= 1280 && screen_h >= 720:  resolutions.push_back(["1280x720",  720]); # project baseline
	if screen_w >= 1366 && screen_h >= 768:  resolutions.push_back(["1366x768",  768]);
	if screen_w >= 1600 && screen_h >= 900:  resolutions.push_back(["1600x900",  900]);
	if screen_w >= 1920 && screen_h >= 1080: resolutions.push_back(["1920x1080", 1080]); # most common res?
	if screen_w >= 2560 && screen_h >= 1440: resolutions.push_back(["2560x1440", 1440]); # my current monitor
	if screen_w >= 3200 && screen_h >= 1800: resolutions.push_back(["3200x1800", 1800]);
	if screen_w >= 3840 && screen_h >= 2160: resolutions.push_back(["3840x2160", 2160]); # 4k, current top we support.
	
	return resolutions;

func _set_res(w: int, h: int):
	get_window().size = Vector2i(w, h);
	
	settings.data['resolution'] = Vector2i(w, h);
	settings.save();
