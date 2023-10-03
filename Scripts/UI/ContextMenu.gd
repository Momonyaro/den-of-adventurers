extends Panel

var section_prefab = preload("res://Prefabs/UI/context_section.tscn");
var section_item_prefab = preload("res://Prefabs/UI/context_section_item.tscn");
@export var menu_parent: Node = null;
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
	var section_title = section.get_child(1);
	var section_icon = section.get_child(0);
	var section_dropdown = section_title.get_child(0);
	var section_content_parent = section_dropdown.get_child(0);


	section_dropdown.visible = false;
	populate_section(section_content_parent, item);
	
	section._id = key;
	if key == 'WIZ_ICON':
		section_icon.visible = true;
		section_title.text = "";
	else:
		section_title.text = key;


func populate_section(parent: Node, item: Dictionary):
	for key in item.keys():
		var entry = item[key];
		var entry_item = section_item_prefab.instantiate();
		parent.add_child(entry_item);

		entry_item._msg_event = command_msg;

		if entry.has('msg'):
			entry_item._action_msg = entry['msg'];
		
		var entry_icon: TextureRect = entry_item.get_child(0).get_child(0);
		var entry_title = entry_item.get_child(0).get_child(1);

		entry_title.text = key;

		var has_icon = entry.has('icon');
		entry_icon.visible = has_icon;
		if has_icon:
			entry_icon.texture = ResourceLoader.load(entry['icon']);




func clear_menu():
	for child in menu_parent.get_children():
		child.queue_free();


func _on_command_msg(msg):
	print(msg);
	if msg == "GAME_QUIT":
		get_tree().quit();
	pass
