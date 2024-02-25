extends BaseState;
class_name OnRequestState;

const WAVE_ANIM_REF = "WAVE";
var assigned_activity: bool = false;

func _init():
	_state_ref = StateReference.ON_REQUEST_START;

func start(animator: AnimationPlayer):
	_animator = animator;
	_animator.play(WAVE_ANIM_REF, 0);
	assigned_activity = false;
	_state_enter_count += 1;

func evaluate(agent: Agent, _adv_state: Adventurer.Status, has_destination: bool, party: Party) -> bool:
	var party_valid = party._status == Party.PartyStatus.GOING_TO_MISSION if party != null else false;
	if party_valid:
		return true;
	return false;

func update(delta: float, agent: Node, camera: Node):
	var cam_pos = camera.global_transform.origin;
	var cam_pos_flat = Vector3(cam_pos.x, 0, cam_pos.z);
	agent.look_at(cam_pos_flat, Vector3.UP);
	agent.rotate_object_local(Vector3.UP, PI);

	var activity_manager: ActivityManager = agent.get_tree().root.get_child(1).get_child(1);
	if activity_manager != null && !assigned_activity:
		var activity_instance = activity_manager.try_get_activity("leave_point", agent);
		#activity_manager.reserve(activity_instance.activity_id, agent);
		agent.current_activity = activity_instance;
		agent.navigation.cancel_nav();
		assigned_activity = true;
		agent.adventurer._status = Adventurer.Status.AWAY;
		print(" [A_MISS] -> <", agent.adventurer.adv_name(), "> Got Activity :: '", activity_instance.activity_id, "'");
	pass;

func end() -> StateReference:
	_state_exit_count += 1;
	return StateReference.NIL;

func state_transition_allowed(state_ref: StateReference) -> bool:
	if _animator.is_playing():
		return false;
		
	match(state_ref):
		StateReference.START_ACTIVITY: return true;
		_: return false;
