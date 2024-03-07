extends Panel

var section_prefab = preload("res://Prefabs/UI/context_section.tscn");
var section_item_prefab = preload("res://Prefabs/UI/context_section_item.tscn");
var section_dropdown_prefab = preload("res://Prefabs/UI/context_section_dropdown_item.tscn");
var section_divider_prefab = preload("res://Prefabs/UI/context_section_divider.tscn");
@export var menu_parent: Node = null;
@export var prompt: Node = null;
@export var notifications: Node = null;
@export var window_manager: Node = null;
var _current_context: String = "";

signal new_context(id: String);
signal command_msg(msg: String);

func _ready():
	create_menu();

func set_context(id: String):
	_current_context = id;
	new_context.emit(id);

func create_menu():
	clear_menu();
	var menu_data = ContextMenuData.get_menu_data();
	for section_key in menu_data.keys():
		create_section(section_key, menu_data[section_key]);
	pass;

func create_section(key: String, item: Dictionary):
	var section = section_prefab.instantiate();
	menu_parent.add_child(section);
	section.name = key;
	var section_title = section.get_child(1);
	var section_icon = section.get_child(0);
	var section_dropdown = section_title.get_child(0);
	var section_content_parent = section_dropdown.get_child(0);


	section_dropdown.visible = false;
	populate_section(section, section_content_parent, item);
	
	section._id = key;
	if key == 'WIZ_ICON':
		section_icon.visible = true;
		section_title.text = "";
	else:
		section_title.text = key;


func populate_section(section:Node, parent: Node, item: Dictionary):
	for key in item.keys():
		var entry = item[key];
		
		if entry.has('exclude_for'):
			if chk_tag(entry):
				continue;
		
		var entry_item = get_prefab(entry['type']);
		parent.add_child(entry_item);
		
		var entry_icon: TextureRect = entry_item.get_child(0).get_child(0);
		var entry_title = entry_item.get_child(0).get_child(1);
		var has_icon = entry.has('icon');
		entry_icon.visible = has_icon;
		
		if entry['type'] == 'divider':
			entry_title.text = key if entry['label_visible'] else "";
			continue;

		entry_item._msg_event = command_msg;
		entry_item._section_parent = section;
		entry_item._id.push_back(key);
		entry_item._obj = entry;
		section.new_item.connect(entry_item._on_new_item);

		if entry.has('msg'):
			entry_item._action_msg = entry['msg'];
		
		if entry.has('items'):
			var items = entry['items'];
			for e_key in items.keys():
				var sub_item = items[e_key];
				if sub_item.has('exclude_for'):
					if chk_tag(sub_item):
						continue;
				
				var submenu_item = get_prefab(sub_item['type']);
				entry_title.get_child(0).get_child(0).add_child(submenu_item);
				submenu_item._msg_event = command_msg;
				submenu_item._section_parent = section;
				submenu_item._id.push_back(e_key);
				submenu_item._obj = sub_item;
				entry_item._id.push_back(e_key);
				section.new_item.connect(submenu_item._on_new_item);
				var sub_icon: TextureRect = submenu_item.get_child(0).get_child(0);
				var sub_title = submenu_item.get_child(0).get_child(1);
				sub_title.text = e_key;
				var has_sub_icon = sub_item.has('icon');
				sub_icon.visible = has_sub_icon;
				submenu_item._action_msg = sub_item['msg'] if sub_item.has('msg') else null;
				if has_sub_icon:
					sub_icon.texture = ResourceLoader.load(sub_item['icon']);
		
		entry_title.text = key;

		if has_icon:
			entry_icon.texture = ResourceLoader.load(entry['icon']);

func get_prefab(type: String) -> Node:
	match type:
		'divider': return section_divider_prefab.instantiate();
		'folder': return section_dropdown_prefab.instantiate();
		_: return section_item_prefab.instantiate();


func clear_menu():
	for child in menu_parent.get_children():
		child.queue_free();

func chk_tag(obj):
	var tags = obj['exclude_for'];
	for tag in tags:
		if OS.has_feature(tag):
			return true;
	return false;
	
func create_notif(icon: Texture2D, content: String, callback: Callable, duration: float = 0):
	notifications.create_notification(icon, content, callback, duration);

func create_prompt(title: String, warning: String, icon: String, ok_option: String, no_option: String, ok_callback: Callable):
	
	var item = {
		'prompt_title': title,
		'prompt_warning': warning,
		'prompt_icon': icon,
		'ok_option': ok_option,
		'ok_callback': ok_callback,
		'no_option': no_option,
	};
	
	prompt.set_prompt.emit(item);

func _on_command_msg(obj):

	if obj.has('type'):
		match (obj['type']):
			'big_action': 
				prompt.set_prompt.emit(obj);
				set_context("");
				return;
			'folder':
				return;
	
	if obj['msg'].begins_with("WINDOW:"):
		window_manager.process_command(obj['msg'], obj['pos']);
		set_context("");
		return;

	match obj['msg']:
		'GAME_SAVE': get_node("/root/Root/DataStore")._save_game(); set_context("");
		"GAME_QUIT": get_tree().quit();
		'GOTO_MAIN': return;
