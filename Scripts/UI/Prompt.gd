extends Panel

@export var _prompt_title: RichTextLabel = null;
@export var _prompt_warning: RichTextLabel = null;
@export var _prompt_icon: TextureRect = null;
@export var _ok_option: Button = null;
@export var _no_option: Button = null;
@export var _ctx_menu: Node = null;

var _obj = null;

signal set_prompt(prompt_obj);

func _ready():
	set_prompt.emit(null)
	_no_option.pressed.connect(_on_no_pressed);
	_ok_option.pressed.connect(_on_ok_pressed);

func _verify_prompt(prompt_obj):
	if !prompt_obj.has_all(['prompt_title', 'prompt_warning']):
		return _prompt_on_fail();
	else:
		return prompt_obj;

func _prompt_on_fail():
	return {
		'prompt_title': 'Execution Mishap...', 
		'prompt_warning': 'Failed to execute action, if error persists, report as a bug.',
		'prompt_icon': 'res://Textures/Icons/pc_sad.png',
		'no_option': 'Okay'
	}

func _on_set_prompt(prompt_obj):
	if prompt_obj == null:
		visible = false;
		get_tree().paused = false;
		return;
	visible = true;
	
	var data = _verify_prompt(prompt_obj);
	_obj = data.duplicate(true);
	_obj['type'] = 'action';
	_prompt_title.text = str(data['prompt_title']);
	_prompt_warning.text = str("[i]", data['prompt_warning'], "[/i]");
	var has_icon = data.has('prompt_icon');
	_prompt_icon.visible = has_icon;
	_prompt_icon.texture = ResourceLoader.load(data['prompt_icon']);
	var has_no = data.has('no_option');
	_no_option.visible = has_no;
	_no_option.text = data['no_option'] if has_no else "";
	var has_ok = data.has('ok_option');
	_ok_option.visible = has_ok;
	_ok_option.text = data['ok_option'] if has_ok else "";
	get_tree().paused = true;
		
	pass # Replace with function body.

func _on_no_pressed():
	set_prompt.emit(null);

func _on_ok_pressed():
	_ctx_menu.command_msg.emit(_obj);
	set_prompt.emit(null);
