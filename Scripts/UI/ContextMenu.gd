extends Panel

var section_prefab = preload("res://Prefabs/UI/context_section.tscn");
var section_item_prefab = preload("res://Prefabs/UI/context_section_item.tscn");
var section_dropdown_prefab = preload("res://Prefabs/UI/context_section_dropdown_item.tscn");
@export var menu_parent: Node = null;
@export var prompt: Node = null;
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
		var entry_item = get_prefab(entry['type']);
		parent.add_child(entry_item);

		entry_item._msg_event = command_msg;
		entry_item._section_parent = section;
		entry_item._id.push_back(key);
		entry_item._obj = entry;
		section.new_item.connect(entry_item._on_new_item);

		if entry.has('msg'):
			entry_item._action_msg = entry['msg'];
		
		var entry_icon: TextureRect = entry_item.get_child(0).get_child(0);
		var entry_title = entry_item.get_child(0).get_child(1);
		
		if entry.has('items'):
			var items = entry['items'];
			for e_key in items.keys():
				var sub_item = items[e_key];
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
				sub_icon.visible = sub_item.has('icon');
				submenu_item._action_msg = sub_item['msg'] if sub_item.has('msg') else null;
		
		entry_title.text = key;

		var has_icon = entry.has('icon');
		entry_icon.visible = has_icon;
		if has_icon:
			entry_icon.texture = ResourceLoader.load(entry['icon']);

func get_prefab(type: String) -> Node:
	match type:
		'folder': return section_dropdown_prefab.instantiate();
		_: return section_item_prefab.instantiate();


func clear_menu():
	for child in menu_parent.get_children():
		child.queue_free();


func _on_command_msg(obj):
	if obj.has('type') and obj['type'] == 'big_action':
		prompt.set_prompt.emit(obj);
		set_context("");
		return;
	
	match obj['msg']:
		"GAME_QUIT": set_context(""); get_tree().quit();
		'GOTO_MAIN': set_context("");
		
	pass