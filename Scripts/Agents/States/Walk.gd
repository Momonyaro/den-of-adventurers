extends BaseState;
class_name WalkState;

const WALK_ANIME_REF = "WALK";

func _init():
    _allow_movement = true;
    _state_ref = StateReference.WALK;

func start(animator: AnimationPlayer):
    _animator = animator;
    _animator.play(WALK_ANIME_REF, 0.3);
    _state_enter_count += 1;

func evaluate(agent: Agent, adv_state: Adventurer.Status, has_destination: bool) -> bool:
    if has_destination:
        return true;
    return false;

func update(delta: float, agent: Node, camera: Node):
    pass;

func end() -> StateReference:
    _state_exit_count += 1;
    return StateReference.NIL;

func state_transition_allowed(state_ref: StateReference) -> bool:
    match(state_ref):
        StateReference.IDLE: return true;
        StateReference.CHEER: return true;
        StateReference.REST: return true;
        _: return false;
