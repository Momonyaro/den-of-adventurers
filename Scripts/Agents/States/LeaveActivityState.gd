extends BaseState;
class_name LeaveActivityState;

var allow_state_transition: bool = false;
var _party: Party = null;
var _agent: Agent = null;
var _exit_pos: Vector3 = Vector3();

func _init():
	_state_ref = StateReference.ON_LEAVE_MAP;
	_state_enter_count += 1;

func start(animator: AnimationPlayer):
	_animator = animator;

func evaluate(agent: Agent, adv_state: Adventurer.Status, has_destination: bool, party: Party) -> bool:
	return false;

func update(delta: float, agent: Node, camera: Node):
	# Check if party has returned.
	if _party == null:
		_party = agent.get_adv_party();
		return;
	
	if _agent == null:
		_agent = agent;

	allow_state_transition = (_party._status == Party.PartyStatus.RETURNED);
	pass;

func end() -> StateReference:
	_agent.global_position = _agent.fallback_position;
	_agent.adventurer._status = Adventurer.Status.IDLE;
	_agent.current_activity = null;
	_state_exit_count += 1;
	return StateReference.NIL;

func state_transition_allowed(state_ref: StateReference) -> bool:
	return allow_state_transition && state_ref != StateReference.START_ACTIVITY;
