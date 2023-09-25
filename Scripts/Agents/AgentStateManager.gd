class_name AgentStateManager;

var _animator: AnimationPlayer = null;
var _current_state: BaseState = BaseState.new();
var _states: Array[BaseState] = [
	BaseState.new(),
	WaveCameraState.new(),
	TestDeleteDismissedState.new(),
	CheerState.new(),
	StartWanderState.new(),
	IdleState.new(), 
	WalkState.new()
];

func _init(animator: AnimationPlayer):
	_animator = animator;

func update(delta: float, adv_state: Adventurer.Status, is_moving: bool, agent: Node, camera: Node):
	for state in _states:
		if _current_state.state_transition_allowed(state._state_ref) && state.evaluate(_current_state._state_ref, adv_state, is_moving):
			_current_state.end();

			_current_state = state;
			_current_state.start(_animator);
			pass;
	
	_current_state.update(delta, agent, camera);
	pass;

func force_state(state_ref: String):
	_current_state = _states.filter(func(a: BaseState): return a.StateReference.keys()[a._state_ref] == state_ref)[0];
	_current_state.start(_animator);
	pass;

func can_move() -> bool:
	return _current_state._allow_movement;

func pick_new_wander() -> bool:
	return _current_state._start_wander;

func allow_recruit() -> bool:
	return _current_state._allow_recruit;
