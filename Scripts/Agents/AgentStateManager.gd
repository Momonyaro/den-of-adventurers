class_name AgentStateManager;

var _self = null;
var _current_state: BaseState = BaseState.new();
var _states: Array[BaseState] = [
	BaseState.new(),
	StartActivityState.new(),
	OnDismissedState.new(),
	OnRecruitState.new(),
	OnRequestState.new(),
	WaveCameraState.new(),
	CheerState.new(),
	RestState.new(),
	StartWanderState.new(),
	IdleState.new(), 
	WalkState.new(),

	LeaveActivityState.new(),
	BedActivityState.new()
];

func _init(agent: Node):
	_self = agent;

func update(delta: float, adv_state: Adventurer.Status, is_moving: bool, agent: Node, camera: Node, party: Party):
	for state in _states:
		if _current_state.state_transition_allowed(state._state_ref) && state.evaluate(agent, adv_state, is_moving, party):
			_current_state.end();

			_current_state = state;
			_current_state.start(_self.get_child(0).get_child(-1));
			#print(BaseState.StateReference.keys()[_current_state._state_ref]);
			pass;
	
	_current_state.update(delta, agent, camera);
	pass;

func force_state(state_ref: String):
	_current_state = _states.filter(func(a: BaseState): return a.StateReference.keys()[a._state_ref] == state_ref)[0];
	_current_state.start(_self.get_child(0).get_child(-1));
	pass;

func force_insert_state(state: BaseState):
	_current_state = state;
	_current_state.start(_self.get_child(0).get_child(-1));
	pass;

func get_current() -> String:
	return BaseState.StateReference.keys()[_current_state._state_ref];

func can_move() -> bool:
	return _current_state._allow_movement;

func pick_new_wander() -> bool:
	return _current_state._start_wander;

func allow_recruit() -> bool:
	return _current_state._allow_recruit;
