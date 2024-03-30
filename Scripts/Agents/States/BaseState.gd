class_name BaseState;
	
var _animator = null;
var _state_enter_count = 0;
var _state_exit_count = 0;
var _state_ref = StateReference.NIL;
var _allow_movement = false;
var _start_wander = false;
var _allow_recruit = true;

func start(animator: AnimationPlayer):
	_animator = animator;
	_state_enter_count += 1;
	pass;
	
func update(delta: float, agent: Node, camera: Node):
	return true;

func evaluate(agent: Agent, adv_state: Adventurer.Status, has_destination: bool, party: Party) -> bool:
	return false;

func end() -> StateReference:
	_state_exit_count += 1;
	return StateReference.NIL;

func state_transition_allowed(state_ref: StateReference) -> bool:
	return true;

enum StateReference { NIL, IDLE, WALK, DEAD, CHEER, START_WANDER, WAVE_AT_CAM, DELETE_DISMISSED, REST, START_ACTIVITY, BED_ACTIVITY, ON_REQUEST_START, ON_LEAVE_MAP, ON_RECRUIT, RECRUIT_WAIT, ON_DISMISSED };
