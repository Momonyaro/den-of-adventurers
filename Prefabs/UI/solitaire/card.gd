extends NinePatchRect

var _card_ref: String = ""; # e.g.: hand:1 or tableau:2:5
var _on_click: Callable;

func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		if !_on_click.is_null():
			_on_click.call(_card_ref);
