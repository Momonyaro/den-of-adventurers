extends Node

# Here we should keep all of the activity nodes as a centralized "thing"
var _activities: Array[Activity] = [];

func _ready():
	register("test1", "bed", self, func (agent): return agent != null);
	register("test2", "chair", self, null);

	assert(try_get_activity("bed", null) == null);
	assert(try_get_activity("chair", null).activity_id == "test2");
	reserve("test2", null); #fail reserve, basically reserving for noone, should reflect that with reservation
	set_free("test2"); #will in this case just remove the error code that was set as the occupier.
	assert(try_get_activity("chair", null).activity_id == "test2");

func try_get_activity(type: String, agent: Agent) -> Activity:
	var activities_of_type = _activities.filter(func (x): return x.type_key == type);
	for activity in activities_of_type:
		if activity.is_available.call(agent):
			if activity.occupied_by == "":
				return activity;
			elif agent != null && activity.occupied_by == agent.adventurer._unique_id:
				return activity;
	
	return null;

func register(id: String, type: String, node: Node, is_available_callback):
	var new_activity = Activity.new();
	
	new_activity.activity_id = id;
	new_activity.type_key = type;
	new_activity.occupied_by = "";
	new_activity.activity_node = node;
	new_activity.is_available = is_available_callback if is_available_callback != null else func (_agent): return true;

	_activities.push_back(new_activity);

func reserve(id: String, reservee: Agent):
	for activity in _activities:
		if activity.activity_id == id && activity.is_available.call(reservee):
			activity.occupied_by = reservee.adventurer._unique_id if reservee != null else "ERR::RERSERVE_FOR_NULL?";
			return;
	print("Failed to find event for ID: ", id);

func set_free(id: String):
	for activity in _activities:
		if activity.activity_id == id:
			activity.occupied_by = "";


class Activity:
	var activity_id: String;
	var type_key: String;
	var occupied_by: String;
	var activity_node: Node;
	var is_available: Callable = func (_agent): return true;
