extends Panel

@onready var _dropdown: Node = get_child(1);
@onready var _current_items: Node = get_child(0).get_child(0);
@export var _disabled = false;

var _is_open = false;
var _items = [];

func _ready():
	self.mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN if _disabled else Control.CURSOR_POINTING_HAND;

func add_item(label: String, id: int = -1):
	_items.push_back([id, label]);
	_sort_items();
	pass;

func _sort_items():
	_items.sort_custom(func(a, b): return a[0] < b[0]);
	_current_items.get_child(0).text = _items[0][1];


func _on_dropdown_click(event:InputEvent):
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		_is_open = !_is_open;
		_dropdown.visible = _is_open;
		self.self_modulate = Color("#F5F5F5") if !_is_open else Color("bac6da");
		_current_items.get_child(1).flip_v = _is_open;

	pass;