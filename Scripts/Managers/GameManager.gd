extends Node
class_name GameManager

var _selected_agent : Agent = null;
@export var _max_adventurers: int = 4;

signal select_agent(new_agent: Agent);

func _ready():
	select_agent.connect(_on_select_agent);
	var window_manager = get_parent().find_child("UI").get_child(1);
	var camera = get_viewport().get_camera_3d();
	select_agent.connect(
		func (a): 
			if a != null: 
				window_manager.process_command("WINDOW:RESET:SYS_INFO:24:24", camera.unproject_position(a.get_child(0).global_position) + Vector2(0, -24))
			else: 
				window_manager.process_command("WINDOW:FORCE_CLOSE:SYS_INFO", Vector2()));
	pass;

func _input(_ev):
	if Input.is_key_pressed(KEY_ESCAPE):
		select_agent.emit(null);

func _on_select_agent(agent: Agent):
	_selected_agent = agent;
