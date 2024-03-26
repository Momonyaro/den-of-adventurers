extends Panel

var _window_base = null;
@onready var _create_btn = $MarginContainer/VBoxContainer/CONFIRM_BTN as Button
@onready var _text_field = $MarginContainer/VBoxContainer/LineEdit as LineEdit
@onready var _text_limit = $MarginContainer/VBoxContainer/HBoxContainer/CAP as Label
var guild_name = "";

func _ready():
	_text_limit.text = str('(0/', _text_field.max_length, ')');
	_text_field.text_changed.connect(_on_text_change);
	_create_btn.pressed.connect(_on_submit);

func _on_text_change(value: String):
	_text_limit.text = str('(', value.length(), '/', _text_field.max_length, ')');
	guild_name = value;
	pass;

func _on_submit():
	if guild_name.length() == 0:
		return;
	
	_window_base.create_prompt(
		'Create new guild?',
		str('Are you sure you want to create guild "', guild_name, '"'),
		'res://Textures/Icons/pc.png',
		'Yes',
		'No',
		func(): get_node("/root/Root/DataStore").start_new_game(guild_name);
	);
