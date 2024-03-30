extends Node3D

@onready var start_point = self.get_child(0);
@onready var activity_point = self.get_child(1);

var activity_manager: ActivityManager = null;
var _agent: Agent = null;
var adventurer = "";

func _ready():
	activity_manager = get_parent();
	activity_manager.register(_get_id(), 'recruit_spawn', self);

func update(state: bool):
	pass;

func is_available(agent: Agent) -> bool:
	_agent = agent;
	return true;

func get_start() -> Vector3:
	return start_point.global_position;

func get_activity_point() -> Node3D:
	return activity_point;

func get_activity_state(agent) -> BaseState:
	return null;

func _get_id():
	return 'RECRUIT_SPAWN';
