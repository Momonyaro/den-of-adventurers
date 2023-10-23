extends Node

var _dropdown: Node = null;

func _ready():
	_dropdown = $dropdown;
	_dropdown.add_item("Scaled", 0);
	_dropdown.add_item("Pixel-Perfect", 1);
	_dropdown.new_current.connect(_on_new_value);
	var default = _get_current();
	_dropdown.set_active_no_event(default[0], default[1])

func _on_new_value(label: String, value: int):
	match value:
		0: 
			get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS;
			ProjectSettings.set('display/window/stretch/mode', Window.CONTENT_SCALE_MODE_CANVAS_ITEMS);
		1: 
			get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_DISABLED;
			ProjectSettings.set('display/window/stretch/mode', Window.CONTENT_SCALE_MODE_DISABLED);
	
	ProjectSettings.save();

func _get_current() -> Array:
	var current_w = ProjectSettings.get('display/window/size/viewport_width');
	var current_h = ProjectSettings.get('display/window/size/viewport_height');
	var current = str(current_w, "x", current_h)
	return [current, current_h];
