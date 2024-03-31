extends CharacterBody3D
class_name Agent

@onready var _model = $little_guy;

@onready var adv_manager : AdventurerManager = get_node("/root/Root/Adventurers");
@onready var agent_manager : AgentManager = get_node("/root/Root/Agents");
@onready var act_manager : ActivityManager = get_node("/root/Root/Activities");
@onready var game_manager : GameManager = get_node("/root/Root/Game");
@onready var timers : TimerContainer = get_node("/root/Root/Timers");

@export var move_speed = 2.0;
@export var idle_time = 2.5;
var adventurer : Adventurer;
var adv_id = "";
var fallback_position: Vector3 = Vector3.ZERO;
var state_manager : AgentStateManager = AgentStateManager.new(self);
var navigation : AgentNavigation = AgentNavigation.new(self, move_speed);
var current_activity: ActivityManager.Activity = null;

func _ready():
	game_manager.select_agent.connect(_on_select_agent);
	$CHAR_NAME.visible = false;
	pass;

func _process(delta):
	var adv_party = adv_manager.get_adventurer_party(adventurer._unique_id);
	state_manager.update(delta, adventurer._status, navigation.is_moving, self, get_node("/root/Root/CAMERA_BASE/SCENE_CAM"), adv_party);

	if adventurer == null:
		agent_manager.agents.erase(adv_id);
		self.queue_free();
		return;

	if state_manager.pick_new_wander() && navigation.nav_finished():
		var point = agent_manager.get_wander_point() as Node3D;

		var pr = point.point_radius;
		var rand_x = randf_range(-pr, pr);
		var rand_z = randf_range(-pr, pr);
		var rand_magnitude = randf_range(0, pr);
		var composite = Vector2(rand_x, rand_z).normalized() * rand_magnitude; 

		var pos_in_point = point.global_position + Vector3(composite.x, 0, composite.y);

		navigation.update_target_pos(pos_in_point);

	if adventurer._status != Adventurer.Status.RESTING && adventurer._status != Adventurer.Status.EXHAUSTED && adventurer._status != Adventurer.Status.RECRUIT:
		adventurer.tick_fatigue(delta * .25);

	pass;

func _physics_process(delta):

	if state_manager.can_move():
		navigation.tick_movement(self, delta);
	pass;

func _on_input_event(_camera, event, _position, _normal, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			game_manager.select_agent.emit(adventurer._unique_id);
	pass;

func _recruit():
	if adventurer._status == Adventurer.Status.RECRUIT && state_manager.allow_recruit():
		adventurer.set_status(Adventurer.Status.IDLE);
		timers.delete_timer(adventurer.TIMER_recruit);
		adventurer.TIMER_recruit = "";

		state_manager.force_state("CHEER");

		$CHAR_NAME.text = adventurer.adv_name();
	pass;

func _dismiss():
	act_manager.remove_all_reservations_for_reservee(self);
	adv_manager.remove_party_member(adv_id);
	timers.delete_timer(adventurer.TIMER_recruit);
	adventurer.adv_dismiss();
	pass;

func get_adv_party() -> Party:
	return adv_manager.get_adventurer_party(adv_id);

func to_dict() -> Dictionary:
	return {
		'adv_id': adv_id,
		'fallback_position': fallback_position,
		'agent_state': state_manager._current_state._state_ref,
		'position': self.global_transform.origin,
		'y_rot': self.rotation_degrees.y,
		'nav_target': navigation._target_pos,
		'current_activity': current_activity.activity_id if current_activity != null else ""
	};

func _on_mouse_entered():
	if adventurer == null:
		pass;
		
	$CHAR_NAME.text = adventurer.adv_name();
	$CHAR_NAME.visible = true;
	pass # Replace with function body.


func _on_mouse_exited():
	$CHAR_NAME.visible = false;
	pass # Replace with function body.

func _on_select_agent(unique_id: String):
	if adventurer == null:
		return;

	if unique_id == adventurer._unique_id:
		$SELECTED.visible = true;
		$SELECTED.get_child(0).play("spin", 0);
	else:
		$SELECTED.visible = false;
		$SELECTED.get_child(0).stop();
