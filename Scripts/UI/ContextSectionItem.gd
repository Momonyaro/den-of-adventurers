extends PanelContainer

var _action_msg = "";
var _section_parent = null;
var _msg_event = null;
var _id: String = "";

func _ready():
	_set_active(false);

func _set_active(active: bool):
	var text = get_child(0).get_child(1);
	var icon = get_child(0).get_child(0);
	self_modulate = Color(0, 0, 0) if active else Color("#F5F5F5");
	text.self_modulate = Color("#F5F5F5") if active else Color(0, 0, 0);
	icon.self_modulate = Color("#F5F5F5") if active else Color(0, 0, 0);

func is_pos_inside(pos: Vector2) -> bool:
	var rects = _deep_search_type();
	for rect in rects:
		if rect.get_global_rect().has_point(get_global_mouse_position()):
			return true;
	
	return false;

func _deep_search_type() -> Array[Node]:
	var toReturn: Array[Node] = [];
	var nodes = get_children();
	nodes.push_front(self);
	while nodes.size() > 0:
		var node = nodes.pop_front();
		nodes.append_array(node.get_children());
		
		if node is PanelContainer:
			toReturn.push_back(node);
	
	return toReturn;

func _gui_input(ev):  
	if ev is InputEventMouseButton and ev.button_index == 1 and ev.pressed:
		_send_msg();

func _send_msg():
	_msg_event.emit(_action_msg);

func _on_new_item(id: String):
	_set_active(id == _id);

func _on_mouse_entered():
	if _section_parent._current_item != _id:
		_section_parent.set_item(_id);
	pass
