extends Node
class_name ActivityManager

# Here we should keep all of the activity nodes as a centralized "thing"
var _activities: Array[Activity] = [];

func _ready():
	pass;

func try_get_activity(type: String, agent: Agent) -> Activity:
	var activities_of_type = _activities.filter(func (x): return x.type_key == type);
	for activity in activities_of_type:
		if activity.activity_node.is_available(agent):
			if activity.occupied_by == "":
				return activity;
			elif agent != null && activity.occupied_by == agent.adv_id:
				return activity;
	
	return null;

func register(id: String, type: String, node: Node):
	var new_activity = Activity.new();
	
	new_activity.activity_id = id;
	new_activity.type_key = type;
	new_activity.occupied_by = "";
	new_activity.activity_node = node;

	_activities.push_back(new_activity);

func reserve(id: String, reservee: Agent):
	for activity in _activities:
		if activity.activity_id == id:
			activity.occupied_by = reservee.adventurer._unique_id if reservee != null else "ERR::RERSERVE_FOR_NULL?";
			return;
	print("Failed to find event for ID: ", id);

func set_free(id: String):
	for activity in _activities:
		if activity.activity_id == id:
			activity.occupied_by = "";

func _on_save_game(save_buffer: Dictionary):
	save_buffer['activities'] = _activities.map(func (a): return a.to_dict());
	pass # Replace with function body.


class Activity:
	var activity_id: String;
	var type_key: String;
	var occupied_by: String;
	var activity_node: Node;

	func to_dict() -> Dictionary:
		return {
			'activity_id': activity_id,
			'type_key': type_key,
			'occupied_by': occupied_by
		};