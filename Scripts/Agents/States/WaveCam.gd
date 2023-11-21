extends BaseState;
class_name WaveCameraState;

const WAVE_ANIM_REF = "WAVE";

func _init():
	_state_ref = StateReference.WAVE_AT_CAM;

func start(animator: AnimationPlayer):
	_animator = animator;
	_animator.play(WAVE_ANIM_REF, 0);
	_state_enter_count += 1;


func evaluate(agent: Agent, _adv_state: Adventurer.Status, has_destination: bool) -> bool:
	if _adv_state == Adventurer.Status.RECRUIT && _state_enter_count == 0:
		return true;
	return false;

func update(delta: float, agent: Node, camera: Node):
	var cam_pos = camera.global_transform.origin;
	var cam_pos_flat = Vector3(cam_pos.x, 0, cam_pos.z);
	agent.look_at(cam_pos_flat, Vector3.UP);
	agent.rotate_object_local(Vector3.UP, PI);
	pass;

func end() -> StateReference:
	_state_exit_count += 1;
	return StateReference.NIL;

func state_transition_allowed(state_ref: StateReference) -> bool:
	if _animator.is_playing():
		return false;
	match(state_ref):
		StateReference.IDLE: return true;
		StateReference.WALK: return true;
		StateReference.CHEER: return true;
		_: return false;
