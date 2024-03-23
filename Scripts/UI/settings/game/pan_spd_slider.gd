extends Node

@onready var _slider = $HBoxContainer/HSlider;
@onready var _reset_btn = $HBoxContainer/reset_btn;
@onready var settings: Persistence = get_node("/root/Root/SettingsMngr/Settings");

var is_unset = true;

func _ready():
	
	_slider.value_changed.connect(_on_new_value)
	_reset_btn.pressed.connect(func (): _on_new_value(8.0); is_unset = true);
	
	var default = _get_current();
	_reset_btn.disabled = default == 8.0;
	is_unset = default == 8.0;

	_slider.set_value_no_signal(default);

func _process(_delta):
	var default = _get_current();
	_reset_btn.disabled = is_unset;
	_slider.set_value_no_signal(default);

func _on_new_value(value: float):
	_set_pan_spd(value);
	is_unset = false;

func _get_current() -> float:
	var data = settings.data;
	var current = data['pan_speed'] if data.has('pan_speed') else 8.0;
	return current;

func _set_pan_spd(value: float):
	var cam_base = get_node("/root/Root/CAMERA_BASE");

	if cam_base != null:
		cam_base.camera_pan_speed = value;

	settings.data['pan_speed'] = value;
	settings.save();
