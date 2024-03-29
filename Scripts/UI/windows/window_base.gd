extends Control
class_name WindowBase

const HEADER_HEIGHT = 24;
const MARGINS_LRD = 6;
const MARGINS_TOP = 4;

@export var content: PackedScene = null;
@export var window_base: PanelContainer = null;
@export var content_parent: Node = null;
@export var win_header_title: Label = null;
@export var win_header_close: Button = null;
@export var win_header_minimize: Button = null;
var _key = "";
var _manager: Node = null;
var _instance: Control = null;

func populate(key, content_obj, window_pos):
	_key = key;
	_instance = ResourceLoader.load(content_obj.content_ref).instantiate();
	content_parent.add_child(_instance);
	var window_size = resize_app();
	self.set_position(window_pos if window_pos != null else _calc_window_offset(position, window_size));
	win_header_title.text = content_obj.title;
	win_header_close.visible = content_obj.has_close_btn if content_obj.has('has_close_btn') else true;
	win_header_close.pressed.connect(_on_win_close);
	win_header_minimize.visible = content_obj.has_minimize_btn if content_obj.has('has_minimize_btn') else false;
	
	var app_properties = _instance.get_property_list().map(func (x): return x.name);
	if app_properties.has('_window_base'):
		_instance._window_base = self;
	if app_properties.has('_on_close_action'):
		win_header_close.pressed.connect(_instance._on_close_action);

	pass;

func resize_app() -> Vector2:
	var window_size = _calc_window_size(_instance.get_global_rect());
	window_base.set_size(window_size);
	return window_size;


func _calc_window_size(content_rect: Rect2) -> Vector2:
	return content_rect.size + Vector2(MARGINS_LRD, MARGINS_LRD) + Vector2(MARGINS_LRD, HEADER_HEIGHT + MARGINS_TOP);

func _calc_window_offset(pos: Vector2, win_size: Vector2) -> Vector2:
	return pos - Vector2(win_size.x / 2, win_size.y / 2);

func _on_win_close():
	play_audio("res://Audio/SFX/UI/click_004.ogg");
	_manager.close_window(_key);

func play_audio(stream_path: String):
	_manager._composer.play(stream_path);

func create_prompt(title: String, warning: String, icon: String, ok_option: String, no_option: String, ok_callback: Callable):
	_manager.create_prompt(title, warning, icon, ok_option, no_option, ok_callback);

func _on_win_header_gui_input(event):
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		_manager._on_grab_header(_key, get_global_mouse_position());
