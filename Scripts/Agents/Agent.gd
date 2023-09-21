extends CharacterBody3D

@onready var _model = $little_guy;

@onready var adv_manager : AdventurerManager = get_node("/root/Root/Adventurers");
@onready var timers : TimerContainer = get_node("/root/Root/Timers");

@onready var nav_target_pos = global_transform.origin;

@export var move_speed = 2.0;
@export var idle_time = 2.5;
var adventurer : Adventurer;
var state_manager : AgentStateManager;
var navigation : AgentNavigation;

func _ready():
	state_manager = AgentStateManager.new(_model.find_child("AnimationPlayer") as AnimationPlayer);
	navigation = AgentNavigation.new(global_transform.origin, $NavigationAgent3D, move_speed);
	$CHAR_NAME.visible = false;
	pass;

func _process(delta):
	state_manager.update(delta, adventurer._status, navigation.is_moving, self, get_node("/root/Root/SCENE_CAM"));

	if state_manager.pick_new_wander() && navigation.nav_finished():
		navigation.update_target_pos(navigation.get_random_pos());

	pass;

func _physics_process(_delta):

	if state_manager.can_move():
		navigation.tick_movement(self);
	pass;

func _on_input_event(_camera, event, _position, _normal, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if adventurer._status == Adventurer.Status.RECRUIT && state_manager.allow_recruit():
				adventurer.set_status(Adventurer.Status.IDLE);
				timers.delete_timer(adventurer.TIMER_recruit);
				adventurer.TIMER_recruit = "";

				state_manager.force_state("CHEER");

				$CHAR_NAME.text = str(adventurer.adv_name(), " : ", Adventurer.Status.keys()[adventurer._status], " : ", BaseState.StateReference.keys()[state_manager._current_state._state_ref]);
	pass;

func _on_mouse_entered():
	if adventurer == null:
		pass;
		
	$CHAR_NAME.text = str(adventurer.adv_name(), " : ", Adventurer.Status.keys()[adventurer._status], " : ", BaseState.StateReference.keys()[state_manager._current_state._state_ref]);
	$CHAR_NAME.visible = true;
	$SELECTED.visible = true;
	$SELECTED.get_child(0).play("spin", 0);
	pass # Replace with function body.


func _on_mouse_exited():
	$CHAR_NAME.visible = false;
	$SELECTED.visible = false;
	$SELECTED.get_child(0).stop();
	pass # Replace with function body.
