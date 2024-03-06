extends Node;
class_name AgentManager;
const D_T = "[AGENT_M]";

var agents = {};
var prefab_agent = preload("res://Prefabs/agent.tscn");
@onready var adv_manager : AdventurerManager = get_node("%Adventurers");
@onready var act_manager : ActivityManager = get_node("%Activities");

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


func _on_load_game(loaded_data: Dictionary):
	agents.clear();
	await get_tree().create_timer(0.1).timeout; # delay to make sure that everything else has been populated.

	for aData in loaded_data['agents']:
		var adv = adv_manager._adventurers[aData['adv_id']]; 
		var instance = prefab_agent.instantiate() as Agent;
		agents[adv._unique_id] = instance;

		instance.name = adv.adv_name();
		instance.adventurer = adv;
		instance.adv_id = adv._unique_id;
		instance.global_transform.origin = SettingsManager.string_to_vector3(str(aData['position']));
		instance.fallback_position = SettingsManager.string_to_vector3(str(aData['fallback_position']));
		instance.current_activity = act_manager.get_activity_by_id(aData['current_activity']);
		instance.navigation._target_pos = SettingsManager.string_to_vector3(str(aData['nav_target']));
		instance.state_manager.force_state(BaseState.StateReference.keys()[aData['agent_state']]);
		instance.rotation_degrees.y = float(aData['y_rot']);
		AgentWardrobe.dress_up(adv, instance);
		add_child(instance);
		print(adv.adv_name());


	#var adventurer : Adventurer;
	#var adv_id = "";
	#var fallback_position: Vector3 = Vector3.ZERO;
	#var state_manager : AgentStateManager;
	#var navigation : AgentNavigation;
	#var current_activity: ActivityManager.Activity = null;

	pass # Replace with function body.
