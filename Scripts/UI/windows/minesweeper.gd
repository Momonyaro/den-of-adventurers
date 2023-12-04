extends Panel

@export var _menu: Panel = null;
@export var _board: Panel = null;
var _window_base: Node = null;

func _on_small_btn_pressed():
	_menu.visible = false;
	_board.visible = true;
	self.set_size(_board.get_global_rect().size);
	_window_base.resize_app();
	pass;
	