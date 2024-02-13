extends Panel
class_name Dropdown

@onready var _dropdown: Node = get_child(2);
@onready var _dropdown_content: Node = get_child(2).get_child(0);
@onready var _current_items: Node = get_child(0).get_child(0);
@export var _disabled = false;
var _dropdown_item = preload("res://Prefabs/UI/components/dropdown_item.tscn");

signal new_current(label: String, value: String, id: int);

var _is_open = false;
var _current_id: int = 0;
var _items = [];

func _process(_delta):
	var mouse_pos = get_global_mouse_position();
	
	$DISABLE_RECT.visible = _disabled;

	for item in _items:
		item._set_active(item._is_hovered(mouse_pos), item._id == _current_id);
	
	if Input.is_action_just_released("click") && _is_open:
		for item in _items:
			if item._hovered:
				_set_active(item);
				break;

func add_item(label: String, value: String, id: int = -1):
	var instance = _dropdown_item.instantiate();
	_dropdown_content.add_child(instance);
	_items.push_back(DropdownItem.new(instance, label, value, id));
	self.self_modulate = Color("bac6da") if _is_open or _disabled else Color("#F5F5F5");
	_sort_items();
	pass;

func clear_items():
	var children = _dropdown_content.get_children();
	for child in children:
		child.queue_free();

	_items = [];

func _get_current_item():
	for item in _items:
		if item._id == _current_id:
			return item;
	return null;

func _sort_items():
	_items.sort_custom(func(a, b): return a._id < b._id);
	_current_items.get_child(0).text = _items[0]._label.text;

func _set_active(item: DropdownItem):
	_current_id = item._id;
	new_current.emit(item._label.text, item._value, item._id);
	set_active_no_event(item._label.text, item._id);
	_set_foldout(false);

func set_active_no_event(label: String, value: int):
	_current_items.get_child(0).text = label;
	_current_id = value;

func _set_foldout(value: bool):
	if _disabled: return;
	_is_open = value;
	_dropdown.visible = _is_open;
	self.self_modulate = Color("bac6da") if _is_open or _disabled else Color("#F5F5F5");
	_current_items.get_child(1).flip_v = _is_open;

func _on_dropdown_click(event:InputEvent):
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		_set_foldout(!_is_open);

	pass;

class DropdownItem:
	var _instance: Node = null;
	var _label: Label = null;
	var _value: String = "";
	var _id: int = -1;
	var _hovered: bool = false;
	
	func _init(instance: Node, label: String, value: String, id: int):
		_instance = instance;
		_label = instance.get_child(0);
		_label.text = label;
		_value = value;
		_id = id;
	
	func _set_active(active: bool, secondary: bool):
		_instance.self_modulate = Color('#000000') if active else Color('#bac6da') if secondary else Color('#f5f5f5');
		_label.self_modulate = Color('#ffffff') if active else Color('#000000');
	
	func _is_hovered(mouse_pos: Vector2) -> bool:
		var rect: Rect2 = _instance.get_global_rect();
		_hovered = rect.has_point(mouse_pos);
		return _hovered;
