extends BaseState;
class_name IdleState;

const IDLE_ANIME_REF = "IDLE";
var _idle_time = randf_range(4, 15);
var _timer = 0;

func _init():
	_state_ref = StateReference.IDLE;

func start(animator: AnimationPlayer):
	_timer = 0;
	_animator = animator;
	_animator.play(IDLE_ANIME_REF, 0.2);
	_state_enter_count += 1;


func evaluate(agent: Agent, _adv_state: Adventurer.Status, has_destination: bool, party: Party) -> bool:
	if !has_destination:
		return true;
	return false;

func update(delta: float, agent: Node, camera: Node):
	_timer += delta;
	pass;

func end() -> StateReference:
	_state_exit_count += 1;
	return StateReference.NIL;

func state_transition_allowed(state_ref: StateReference) -> bool:
	match(state_ref):
		StateReference.WALK: return true;
		StateReference.START_WANDER: return (_timer >= _idle_time);
		StateReference.CHEER: return true;
		StateReference.REST: return true;
		StateReference.ON_REQUEST_START: return true;
		StateReference.ON_DISMISSED: return true;
		_: return false;
