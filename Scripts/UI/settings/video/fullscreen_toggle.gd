extends Node

var _toggle: CheckBox = null;
@onready var settings: Persistence = get_node("/root/Root/SettingsMngr/Settings");
@onready var _composer: Node = get_node("/root/Root/UI/Composer");

func _ready():
	var data = settings.data;
	var value = (data['fullscreen'] as Window.Mode) if data.has('fullscreen') else Window.Mode.MODE_WINDOWED;
	_toggle = $CheckBox as CheckBox;
	_toggle.pressed.connect(_on_new_value);

	_toggle.button_pressed = value;

func _on_new_value():
	var current_mode = get_window().mode == Window.Mode.MODE_FULLSCREEN;
	if  current_mode:
		_set_mode(Window.Mode.MODE_WINDOWED);
		_composer.play("res://Audio/SFX/UI/minimize_008.ogg");
	else:
		_set_mode(Window.Mode.MODE_FULLSCREEN);
		_composer.play("res://Audio/SFX/UI/maximize_006.ogg");

func _set_mode(mode: Window.Mode):
	var data = settings.data;
	get_window().mode = mode;
	var current = SettingsManager.string_to_vector2i(str(data['resolution'])) if data.has('resolution') else get_window().size;
	_set_res(current.x, current.y);
	settings.data['fullscreen'] = int(mode);
	settings.save();

func _set_res(w: int, h: int):
	get_window().size = Vector2i(w, h);
	
	settings.data['resolution'] = Vector2i(w, h);
