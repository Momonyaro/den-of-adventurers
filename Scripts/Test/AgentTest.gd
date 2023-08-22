extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D;
@onready var model = $little_guy;
@onready var adv_manager : AdventurerManager = get_node("/root/Root/Adventurers");
@onready var timers : TimerContainer = get_node("/root/Root/Timers");
@onready var nav_target_pos = global_transform.origin;
@onready var start_point = global_transform.origin;

@export var move_speed = 2.0;
@export var idle_time = 2.5;
var timer = 0;
var current_anim = "CHEER";
var anim_player = null;
var adv_id = "";

func _ready():
	$CHAR_NAME.visible = false;
	anim_player = model.find_child("AnimationPlayer");
	anim_player.play("CHEER", 0);
	var test = model.find_child("HAT_MAGICIAN");
	if bool(randi_range(0, 1)):
		test.hide();
	else:
		test.show();

func _process(delta):
	if current_anim == "CHEER":
		pass;
	
	if nav_agent.is_navigation_finished():
		timer += delta;
		if timer >= idle_time:
			timer = 0;
			update_target_pos(get_random_pos());

func _physics_process(delta):
	var pos = global_transform.origin;
	var next_pos = nav_agent.get_next_path_position();
	if (nav_agent.distance_to_target() > .1 and next_pos != pos) and current_anim != "CHEER":
		look_at(next_pos, Vector3.UP);
		self.rotate_object_local(Vector3.UP, PI);
	var new_velocity: Vector3 = (next_pos - pos).normalized() * move_speed;
	
	if pos.distance_to(next_pos) < .1 or current_anim == "CHEER":
		new_velocity = Vector3.ZERO;
	
	if new_velocity.length() > 0:
		if try_set_anim("WALK"):
			anim_player.play(current_anim, 0.2);
	else:
		if try_set_anim("IDLE"):
			anim_player.play(current_anim, 0.25);
	
	
	velocity = new_velocity;
	move_and_slide();

func update_target_pos(target_pos):
	nav_target_pos = target_pos;
	nav_agent.target_position = target_pos;

func get_random_pos() -> Vector3:
	var rand_x = randf_range(-3, 3);
	var rand_z = randf_range(-3, 3);
	var rand_point = start_point + Vector3(rand_x, 0, rand_z);
	
	return rand_point;

func try_set_anim(name: String) -> bool:
	if current_anim == "CHEER" and anim_player.is_playing():
		return false;
	if name == current_anim: 
		return false;
	current_anim = name;
	return true;

func _on_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var adv: Adventurer = adv_manager._adventurers[adv_id];
			if adv._status == Adventurer.Status.RECRUIT:
				adv.set_status(Adventurer.Status.IDLE);
				timers.delete_timer(adv.TIMER_recruit);
				adv.TIMER_recruit = "";
				$CHAR_NAME.text = str(adv.name(), " : ", Adventurer.Status.keys()[adv._status]);
				if try_set_anim("CHEER"):
					anim_player.play(current_anim, 0.25);
	pass;


func _on_mouse_entered():
	if not adv_manager._adventurers.has(adv_id):
		pass;
		
	var adv = adv_manager._adventurers[adv_id];
	$CHAR_NAME.text = str(adv.name(), " : ", Adventurer.Status.keys()[adv._status]);
	$CHAR_NAME.visible = true;
	pass # Replace with function body.


func _on_mouse_exited():
	$CHAR_NAME.visible = false;
	pass # Replace with function body.
