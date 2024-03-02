extends Node

var _toggle: CheckBox = null;
@onready var settings: Persistence = get_node("/root/Root/SettingsMngr/Settings");

func _ready():
	var data = settings.data;
	var value = (data['fullscreen'] as Window.Mode) if data.has('fullscreen') else Window.Mode.MODE_WINDOWED;
	_toggle = $CheckBox as CheckBox;
	_toggle.pressed.connect(_on_new_value);

	_toggle.button_pressed = value;

func _on_new_value():
	var current_mode = get_window().mode == Window.Mode.MODE_EXCLUSIVE_FULLSCREEN;
	if  current_mode:
		_set_mode(Window.Mode.MODE_WINDOWED);
	else:
		_set_mode(Window.Mode.MODE_EXCLUSIVE_FULLSCREEN);

func _set_mode(mode: Window.Mode):
	get_window().mode = mode;
	settings.data['fullscreen'] = int(mode);
	settings.save();
