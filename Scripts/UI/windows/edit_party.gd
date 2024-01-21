extends Panel

var _window_base: Node = null;

func _ready():
	var title_edit = get_node("LineEdit") as LineEdit;
	var title_label = get_node("LineEdit/Label") as Label;
	title_label.text = str("Title ", "(0/", title_edit.max_length, ")");

func _on_close_btn_pressed():
	_window_base._on_win_close();
	pass # Replace with function body.

func _on_title_text_changed(new_text:String):
	var title_edit = get_node("LineEdit") as LineEdit;
	var title_label = get_node("LineEdit/Label") as Label;
	title_label.text = str("Title ", "(", new_text.length(), "/", title_edit.max_length, ")");

	pass # Replace with function body.
