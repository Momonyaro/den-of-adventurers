extends PanelContainer

var ctx_menu = null;
var _active = false;
var _id = "";

func _ready():
	ctx_menu = get_parent().get_parent().get_parent();
	ctx_menu.new_context.connect(_on_new_context);
	_set_active(false);

func _set_active(active: bool):
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
