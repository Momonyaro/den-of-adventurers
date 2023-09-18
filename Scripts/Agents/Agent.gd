extends CharacterBody3D

@onready var _agent = $NavigationAgent3D;
@onready var _model = $little_guy;

@onready var adv_manager : AdventurerManager = get_node("/root/Root/Adventurers");
@onready var timers : TimerContainer = get_node("/root/Root/Timers");

@onready var nav_target_pos = global_transform.origin;
@onready var start_point = global_transform.origin;

@export var move_speed = 2.0;
@export var idle_time = 2.5;
var anim_player : AnimationPlayer = null;
var adventurer : Adventurer;
var state_manager : AgentStateManager;

func _ready():
	anim_player = _model.find_child("AnimationPlayer");
	state_manager = AgentStateManager.new(anim_player as AnimationPlayer);
	$CHAR_NAME.visible = false;
	pass;

func _process(delta):
	state_manager.update(delta, adventurer._status, false);
	pass;

func _on_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if adventurer._status == Adventurer.Status.RECRUIT && state_manager.allow_recruit():
				adventurer.set_status(Adventurer.Status.IDLE);
				timers.delete_timer(adventurer.TIMER_recruit);
				adventurer.TIMER_recruit = "";

				state_manager.force_state("CHEER");

				$CHAR_NAME.text = str(adventurer.name(), " : ", Adventurer.Status.keys()[adventurer._status]);
	pass;

func _on_mouse_entered():
	if adventurer == null:
		pass;
		
	$CHAR_NAME.text = str(adventurer.name(), " : ", Adventurer.Status.keys()[adventurer._status]);
	$CHAR_NAME.visible = true;
	pass # Replace with function body.


func _on_mouse_exited():
	$CHAR_NAME.visible = false;
	pass # Replace with function body.
