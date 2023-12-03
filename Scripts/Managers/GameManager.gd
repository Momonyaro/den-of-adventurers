extends Node
class_name GameManager

var _selected_agent : String = "";
@export var _max_adventurers: int = 4;

signal select_agent(unique_id: String);

func _ready():
	select_agent.connect(_on_select_agent);
	var window_manager = get_parent().find_child("UI").get_child(1);
	var agent_manager: AgentManager = get_node("/root/Root/Agents");
	var camera = get_viewport().get_camera_3d();
	select_agent.connect(
		func (a): 
			var agent = null;
			if agent_manager.agents.has(a):
				agent = agent_manager.agents[a];
				window_manager.process_command("WINDOW:RESET:ADV_PREVIEW:16:16", camera.unproject_position(agent.get_child(0).global_position) + Vector2(0, -24))
			else:
				window_manager.process_command("WINDOW:FORCE_CLOSE:ADV_PREVIEW", Vector2()));
	pass;

func _input(_ev):
	if Input.is_key_pressed(KEY_ESCAPE):
		select_agent.emit("");

func _on_select_agent(unique_id: String):
	_selected_agent = unique_id;
