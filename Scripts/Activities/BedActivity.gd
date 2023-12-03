extends Node3D

@onready var start_point = self.get_child(0);
@onready var activity_point = self.get_child(1);
@onready var zzz_particles = self.get_child(2) if self.get_child_count() > 2 else null;

var activity_manager: ActivityManager = null;
var adventurer = "";

func _ready():
	activity_manager = get_parent();
	activity_manager.register(_get_id(), 'bed', self, is_available);

func update(state: bool):
	zzz_particles.emitting = state;

func is_available(agent: Agent) -> bool:
	if adventurer == "" || adventurer == agent.adv_id:
		adventurer = agent.adv_id;
		return true;
	return false;

func get_start() -> Vector3:
	return start_point.global_position;

func get_activity_point() -> Node3D:
	return activity_point;

func get_activity_state() -> BaseState:
	var activity_state = BedActivityState.new();
	activity_state._activity = self;
	return activity_state;

func _get_id():
	var pos = self.global_position;
	var str_pos = str(pos).replace(',', '_').replace(' ', '').replace('(', '[').replace(')', ']');
	return 'BED' + str_pos;
