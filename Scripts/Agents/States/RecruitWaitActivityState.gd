extends BaseState;
class_name RecruitWaitActivityState;

var allow_state_transition: bool = false;
var _party: Party = null;
var _agent: Agent = null;
var _exit_pos: Vector3 = Vector3();
const IDLE_ANIME_REF = "IDLE";

func _init():
	_state_ref = StateReference.RECRUIT_WAIT;
	_state_enter_count += 1;

func start(animator: AnimationPlayer):
	_animator = animator;
	_animator.play(IDLE_ANIME_REF, 0.3);

func evaluate(agent: Agent, adv_state: Adventurer.Status, has_destination: bool, party: Party) -> bool:
	return false;

func update(delta: float, agent: Node, camera: Node):
	allow_state_transition = agent.adventurer._status != Adventurer.Status.RECRUIT;
	pass;

func end() -> StateReference:
	_agent.global_position = _agent.fallback_position;
	_agent.current_activity = null;
	_state_exit_count += 1;
	return StateReference.NIL;

func state_transition_allowed(state_ref: StateReference) -> bool:
	return allow_state_transition && state_ref != StateReference.START_ACTIVITY;
