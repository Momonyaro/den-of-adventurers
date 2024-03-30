extends BaseState;
class_name OnDismissedState;

var assigned_activity: bool = false;

func _init():
	_state_ref = StateReference.ON_DISMISSED;

func start(animator: AnimationPlayer):
	_animator = animator;
	assigned_activity = false;
	_state_enter_count += 1;

func evaluate(agent: Agent, _adv_state: Adventurer.Status, has_destination: bool, party: Party) -> bool:
	if _adv_state == Adventurer.Status.DISMISSED:
		return true;
	return false;

func update(delta: float, agent: Node, camera: Node):
	var activity_manager: ActivityManager = agent.get_node("/root/Root/Activities");
	if activity_manager != null && !assigned_activity:
		var activity_instance = activity_manager.try_get_activity("dismissed_point", agent);
		agent.current_activity = activity_instance;
		agent.navigation.cancel_nav();
		assigned_activity = true;
		print(" [A_MISS] -> <", agent.adventurer.adv_name(), "> Got Activity :: '", activity_instance.activity_id, "'");
	pass;

func end() -> StateReference:
	_state_exit_count += 1;
	return StateReference.NIL;

func state_transition_allowed(state_ref: StateReference) -> bool:
	match(state_ref):
		StateReference.START_ACTIVITY: return true;
		_: return false;
