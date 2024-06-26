extends BaseState;
class_name RestState;

func _init():
	_state_ref = StateReference.REST;
	_state_enter_count += 1;

func start(animator: AnimationPlayer):
	_animator = animator;

func evaluate(agent: Agent, adv_state: Adventurer.Status, has_destination: bool, party: Party) -> bool:
	var has_party = party != null;
	var party_is_gone = false;
	if has_party:
		party_is_gone = party._status != Party.PartyStatus.IDLE;

	if (adv_state == Adventurer.Status.RESTING || adv_state == Adventurer.Status.EXHAUSTED) && agent.current_activity == null && !party_is_gone:
		return true;
	return false;

func update(delta: float, agent: Node, camera: Node):
	if agent.current_activity != null:
		return;

	var activity_manager: ActivityManager = agent.get_node("/root/Root/Activities");
	if activity_manager != null:
		var activity_instance = activity_manager.try_get_activity("bed", agent);
		activity_manager.reserve(activity_instance.activity_id, agent);
		agent.current_activity = activity_instance;
		agent.navigation.cancel_nav();
		print(" [A_REST] -> <", agent.adventurer.adv_name(), "> Got Activity :: '", activity_instance.activity_id, "'");
	pass;

func end() -> StateReference:
	_state_exit_count += 1;
	return StateReference.NIL;

func state_transition_allowed(state_ref: StateReference) -> bool:
	match(state_ref):
		StateReference.START_ACTIVITY: return true;
		_: return false;
