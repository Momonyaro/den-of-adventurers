extends Node;
class_name AgentManager;
const D_T = "[AGENT_M]";

var prefab_agent = preload("res://Prefabs/agent.tscn");
@onready var adv_manager : AdventurerManager = get_node("%Adventurers");

func _ready():
	adv_manager.new_recruit.connect(_on_new_recruit);
	pass;

func _on_new_recruit(id: String):
	var instance = prefab_agent.instantiate();
	var name = adv_manager._adventurers[id].name();
	instance.name = name;
	instance.adv_id = id;
	add_child(instance);
	instance.set_position(Vector3(0, 0, 0));
	pass;
