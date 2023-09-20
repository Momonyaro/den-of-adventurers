extends BaseState;
class_name CheerState;

const CHEER_ANIME_REF = "CHEER";

func _init():
	_allow_recruit = false;
	_state_ref = StateReference.CHEER;

func start(animator: AnimationPlayer):
	_animator = animator;
	_animator.play(CHEER_ANIME_REF, 0.1);

func evaluate(curr_state: StateReference, adv_state: Adventurer.Status, has_destination: bool) -> bool:
	return false;

func update(delta: float):
	pass;

func end() -> StateReference:
	return StateReference.IDLE;

func state_transition_allowed(state_ref: StateReference) -> bool:
	return !_animator.is_playing();
