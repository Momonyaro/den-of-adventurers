extends Node

var _dropdown: Node = null;

func _ready():
	_dropdown = $dropdown;
	_dropdown.add_item("Scaled", "", Window.CONTENT_SCALE_MODE_CANVAS_ITEMS);
	_dropdown.add_item("Pixel-Perfect", "", Window.CONTENT_SCALE_MODE_DISABLED);
	_dropdown.new_current.connect(_on_new_value);
	var default = _get_current();
	_dropdown.set_active_no_event(default[0], default[1])

func _on_new_value(label: String, value: String, id: int):
	get_tree().root.content_scale_mode = id;
	
	#ProjectSettings.save();

func _get_current() -> Array:
	var current = get_tree().root.content_scale_mode;
	match (current):
		Window.CONTENT_SCALE_MODE_CANVAS_ITEMS: return ["Scaled", Window.CONTENT_SCALE_MODE_CANVAS_ITEMS];
		_: return ["Pixel-Perfect", current];
