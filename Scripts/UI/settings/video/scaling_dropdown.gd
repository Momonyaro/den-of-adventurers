extends Node

var _dropdown: Node = null;

func _ready():
	_dropdown = $dropdown;
	_dropdown.add_item("Scaled", 0);
	_dropdown.add_item("Pixel-Perfect", 1);
