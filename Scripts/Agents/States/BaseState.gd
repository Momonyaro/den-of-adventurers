class_name BaseState;
    
var _animator = null;
var _state_ref = StateReference.NIL;
var _allow_movement = false;
var _start_wander = false;
var _allow_recruit = true;

func start(animator: AnimationPlayer):
    _animator = animator;
    pass;
    
func update(delta: float):
    return true;

func evaluate(curr_state: StateReference, adv_state: Adventurer.Status, has_destination: bool) -> bool:
    return false;

func end() -> StateReference:
    return StateReference.NIL;

func state_transition_allowed(state_ref: StateReference) -> bool:
    return true;

enum StateReference { NIL, IDLE, WALK, DEAD, CHEER, START_WANDER };