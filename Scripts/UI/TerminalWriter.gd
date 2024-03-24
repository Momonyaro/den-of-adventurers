extends Control

@onready var line_item = preload('res://Prefabs/UI/term_line_item.tscn');
var line_instances = [];

func _ready():
	await build_terminal();
	get_tree().change_scene_to_file("res://Scenes/BOOT_OS.tscn");
	pass;

func build_terminal():
	var items = TerminalPrintData.get_terminal_text() as Array;
	var node = null;

	for item in items:
		var instruction = item['instruction'];
		if node != null:
			node.active = false;
		node = parse_instruction(instruction, item);
		node.active = true;
		await get_tree().create_timer(item['duration']).timeout;

	pass;


func parse_instruction(instruction: String, item: Dictionary) -> Node:
	var text = item['text'];
	var split = instruction.split('$');
	match split[0]:
		'insert':
			var new_instance = get_line_instance();
			new_instance.get_child(0).text = text;
			line_instances.push_back(new_instance);
			return new_instance;
		'append':
			var index = int(split[1]);
			var instance = line_instances[index];
			instance.get_child(0).text += text;
			return instance;
		'overwrite':
			var index = int(split[1]);
			var instance = line_instances[index];
			instance.get_child(0).text = text;
			return instance;
	return null;


func get_line_instance() -> Node:
	var instance = line_item.instantiate();
	$MarginContainer/VBoxContainer.add_child(instance);

	return instance;
