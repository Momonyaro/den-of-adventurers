extends Node

var _dropdown: Node = null;
@onready var settings: Persistence = get_node("/root/Root/SettingsMngr/Settings");

func _ready():
	
	_dropdown = $dropdown;
		
	if OS.has_feature('web'):
		_dropdown._disabled = true;
		_dropdown.tooltip_text = "Not available in web version."
	else:
		_dropdown.new_current.connect(_on_new_value);
	
	var options = _get_options();
	
	for option in options:
		_dropdown.add_item(option[0], "", option[1]);
	
	var default = _get_current();
	_dropdown.set_active_no_event(default[0], default[1])

func _process(_delta):
	var default = _get_current();
	_dropdown.set_active_no_event(default[0], default[1]);

func _on_new_value(_label: String, _value: String, id: int):
	_set_timer(id);
	settings.get_parent().reset_autosave_timer(id);

func _get_current() -> Array:
	var data = settings.data;
	var current = data['autosave_time'] if data.has('autosave_time') else 15 * 60;
	var current_str = str(roundi(current / 60.0), ' Minutes') if current > 0 else 'Never';
	return [current_str, current];

func _get_options() -> Array: # only 16:9 support for the moment at least.
	var options = [
		['Never', 0],
		['5 Minutes',  5  * 60],
		['10 Minutes', 10 * 60],
		['15 Minutes', 15 * 60],
		['30 Minutes', 30 * 60]
	];
	return options;

func _set_timer(seconds: int):
	
	settings.data['autosave_time'] = seconds;
	settings.save();
