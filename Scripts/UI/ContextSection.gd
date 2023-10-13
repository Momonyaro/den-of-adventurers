extends PanelContainer

var ctx_menu = null;
var _current_item: String = "";
var _active = false;
var _id = "";
@onready var _dropdown = get_child(1).get_child(0);
@onready var _dropdown_content_parent = get_child(1).get_child(0).get_child(0);

signal new_item(id: String);

func _ready():
	ctx_menu = get_parent().get_parent().get_parent();
	ctx_menu.new_context.connect(_on_new_context);
	_set_active(false);

func _process(_delta):
	var mouse_pos = get_global_mouse_position();
	var items = _dropdown_content_parent.get_children();
	var inside_panel = _dropdown_content_parent.get_global_rect().has_point(mouse_pos)
	var nouse_inside = items.any(func(i): return i.is_pos_inside(mouse_pos));
	if !nouse_inside && !inside_panel && _current_item != "":
		set_item("");

func set_item(id: String):
	_current_item = id;
	new_item.emit(id);

func _set_active(active: bool):
	set_item("");
	var text = get_child(1);
	var icon = get_child(0);
	self_modulate = Color(0, 0, 0) if active else Color("#F5F5F5");
	text.self_modulate = Color("#F5F5F5") if active else Color(0, 0, 0);
	icon.self_modulate = Color("#F5F5F5") if active else Color(0, 0, 0);
	var section_dropdown = text.get_child(0);

	section_dropdown.visible = active;

	_active = active;

func _on_new_context(id: String):
	_set_active(_id == id);
	pass;

func _gui_input(ev):  
	if ev is InputEventMouseButton and ev.button_index == 1 and ev.pressed:
		ctx_menu.set_context(_id if not _active else "");


func _on_mouse_entered():
	var current = ctx_menu._current_context
	if current != "" && current != _id:
		ctx_menu.set_context(_id);
	pass
