extends BaseState;
class_name StartWanderState;

func _init():
	_start_wander = true;
	_state_ref = StateReference.START_WANDER;
	_state_enter_count += 1;

func start(animator: AnimationPlayer):
	_animator = animator;

func evaluate(agent: Agent, adv_state: Adventurer.Status, has_destination: bool, party: Party) -> bool:
	if adv_state == Adventurer.Status.IDLE && agent.state_manager._current_state._state_ref == StateReference.IDLE && !has_destination:
		return true;
	return false;

func update(delta: float, agent: Node, camera: Node):
	pass;

func end() -> StateReference:
	_state_exit_count += 1;
	return StateReference.NIL;

func state_transition_allowed(state_ref: StateReference) -> bool:
	match(state_ref):
		StateReference.WALK: return true;
		StateReference.CHEER: return true;
		_: return false;
