extends BaseState;
class_name StartActivityState;

var _party: Party = null;
var _agent: Agent = null;

func _init():
	_allow_movement = true;
	_state_ref = StateReference.START_ACTIVITY;
	_state_enter_count += 1;

func start(animator: AnimationPlayer):
	_animator = animator;

func evaluate(agent: Agent, adv_state: Adventurer.Status, has_destination: bool, party: Party) -> bool:
	_party = party;
	return agent.current_activity != null;

func update(delta: float, agent: Node, camera: Node):
	var pathing = agent.navigation;
	var activity = agent.current_activity.activity_node;
	_agent = agent as Node3D;

	var start_pos = activity.get_start();
	if _animator.assigned_animation != "WALK":
		_animator.play("WALK", 0.2);

	pathing.update_target_pos(start_pos);
	if _agent.global_position.distance_to(start_pos) < 0.1:
		var activity_point = activity.get_activity_point();
		_agent.global_position = activity_point.global_position;
		_agent.global_rotation = activity_point.global_rotation;
		var activity_state = activity.get_activity_state();
		activity_state._party = _party;
		activity_state._agent = agent;
		_agent.state_manager.force_insert_state(activity_state);

	pass;

func end() -> StateReference:
	_state_exit_count += 1;
	_agent.current_activity = null;
	return StateReference.NIL;

func state_transition_allowed(state_ref: StateReference) -> bool:
	match(state_ref):
		_: return false;
