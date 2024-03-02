extends Node
class_name GameManager

var _selected_agent : String = "";
var guild_data: GuildData = GuildData.new();
var start_date: Dictionary = Time.get_datetime_dict_from_system();
var guild_info: Node = null;

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

func _on_load_game(loaded_data):
	guild_data = GuildData.from_dict(loaded_data['guild_data']);

	guild_info = get_parent().find_child("UI").get_child(-1).get_child(0).get_child(1);
	guild_info.populate(guild_data);

func _on_save_game(save_buffer: Dictionary):
	save_buffer['guild_data'] = guild_data.to_dict();
