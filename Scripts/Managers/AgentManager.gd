extends Node;
class_name AgentManager;
const D_T = "[AGENT_M]";

var agents = {};
var prefab_agent = preload("res://Prefabs/agent.tscn");
@onready var adv_manager : AdventurerManager = get_node("%Adventurers");

func _ready():
	adv_manager.new_recruit.connect(_on_new_recruit);
	Console.add_command("recruit", _recruit_agent, 1)
	pass;

func _on_new_recruit(id: String):
	var instance = prefab_agent.instantiate();
	var adv = adv_manager._adventurers[id];
	agents[adv._unique_id] = instance;
	instance.name = adv.adv_name();
	instance.adventurer = adv;
	instance.adv_id = adv._unique_id;
	AgentWardrobe.dress_up(adv, instance);
	add_child(instance);
	instance.set_position(Vector3(0, 0, 0));
	pass;

func _recruit_agent(adv_id: String):
	var agents = get_children();
	for agent in agents:
		if agent.adventurer._unique_id == adv_id or adv_id.replace('_', ' ').to_lower().contains(agent.adventurer.adv_name().to_lower()):
			agent._recruit();
			Console.print_line(str("Recruited ", agent.adventurer.adv_name()));
			return;
	pass;


func _on_save_game(save_buffer: Dictionary):
	save_buffer['agents'] = agents.values().map(func (a): return a.to_dict());
	pass # Replace with function body.
