extends Node

var _toggle: CheckBox = null;

func _ready():
	
	_toggle = $CheckBox as CheckBox;
	_toggle.pressed.connect(_on_new_value);

	var default = get_window().mode == Window.Mode.MODE_EXCLUSIVE_FULLSCREEN;
	_toggle.button_pressed = default;

func _on_new_value():
	var current_mode = get_window().mode == Window.Mode.MODE_EXCLUSIVE_FULLSCREEN;
	if  current_mode:
		_set_mode(Window.Mode.MODE_WINDOWED);
	else:
		_set_mode(Window.Mode.MODE_EXCLUSIVE_FULLSCREEN);
	#ProjectSettings.save();

func _set_mode(mode: Window.Mode):
	get_window().mode = mode;
