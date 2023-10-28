extends Control
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

# func _ready():
# 	var data = WindowData.get_window_data("SYS_INFO");
# 	print('populting window with ', data[0]);
# 	populate(data[1]);

func populate(key, content_obj):
	_key = key;
	var instance = ResourceLoader.load(content_obj.content_ref).instantiate();
	content_parent.add_child(instance);
	var window_size = _calc_window_size(instance.get_global_rect());
	self.set_position(_calc_window_offset(position, window_size));
	window_base.set_size(window_size);

	win_header_title.text = content_obj.title;
	win_header_close.visible = content_obj.has_close_btn if content_obj.has('has_close_btn') else true;
	win_header_close.pressed.connect(_on_win_close);
	win_header_minimize.visible = content_obj.has_minimize_btn if content_obj.has('has_minimize_btn') else false;
	pass;

func _calc_window_size(content_rect: Rect2) -> Vector2:
	return content_rect.size + Vector2(MARGINS_LRD, MARGINS_LRD) + Vector2(MARGINS_LRD, HEADER_HEIGHT + MARGINS_TOP);

func _calc_window_offset(pos: Vector2, win_size: Vector2) -> Vector2:
	return pos - Vector2(win_size.x / 2, win_size.y / 2);

func _on_win_close():
	_manager.close_window(_key);


func _on_win_header_gui_input(event):
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		_manager._on_grab_header(_key, get_global_mouse_position());