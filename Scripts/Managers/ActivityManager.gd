extends Node

# Here we should keep all of the activity nodes as a centralized "thing"
var _activities: Array[Activity] = [];

func _ready():
	register("test1", "bed", self);
	register("test2", "chair", self);

	reserve("test1", "me");
	assert(try_get_activity("bed", null) == null);
	assert(try_get_activity("chair", null).activity_id == "test2");
	reserve("test2", "me");
	assert(try_get_activity("chair", null) == null);

func try_get_activity(type: String, agent: Agent) -> Activity:
	var activities_of_type = _activities.filter(func (x): return x.type_key == type);
	for activity in activities_of_type:
		if activity.occupied_by == "":
			return activity;
		elif agent != null && activity.occupied_by == agent.adventurer._unique_id:
			return activity;
	
	return null;

func register(id: String, type: String, node: Node):
	var new_activity = Activity.new();
	
	new_activity.activity_id = id;
	new_activity.type_key = type;
	new_activity.occupied_by = "";
	new_activity.activity_node = node;

	_activities.push_back(new_activity);

func reserve(id: String, reservee: String):
	for activity in _activities:
		if activity.activity_id == id:
			activity.occupied_by = reservee;
			return;
	print("Failed to find event for ID: ", id);


class Activity:
	var activity_id: String;
	var type_key: String;
	var occupied_by: String;
	var activity_node: Node;
