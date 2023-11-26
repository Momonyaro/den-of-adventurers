extends BaseState;
class_name BedActivityState;

var is_fatigued: bool = true;
var _agent = null;

func _init():
	_state_ref = StateReference.BED_ACTIVITY;
	_state_enter_count += 1;

func start(animator: AnimationPlayer):
	_animator = animator;
	_animator.play("SLEEP", 0);

func evaluate(agent: Agent, adv_state: Adventurer.Status, has_destination: bool) -> bool:
	return true;

func update(delta: float, agent: Node, camera: Node):
	agent.adventurer.tick_fatigue(delta);
	is_fatigued = (agent.adventurer._status == Adventurer.Status.RESTING || agent.adventurer._status == Adventurer.Status.EXHAUSTED);
	_agent = agent;
	var _activity = _agent.current_activity;
	if _activity != null:
		_activity.activity_node.update(true);
	pass;

func end() -> StateReference:
	_state_exit_count += 1;
	_agent.current_activity.activity_node.update(false);
	_agent.current_activity = null;
	return StateReference.NIL;

func state_transition_allowed(state_ref: StateReference) -> bool:
	if state_ref == BaseState.StateReference.START_ACTIVITY:
		return false;
	return !is_fatigued;
