extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D;
@onready var model = $little_guy;
@onready var nav_target_pos = global_transform.origin;
@onready var start_point = global_transform.origin;

@export var move_speed = 5.0;
@export var idle_time = 2.5;
var timer = 0;
var current_anim = "CHEER";
var anim_player = null;

func _ready():
	anim_player = model.find_child("AnimationPlayer");
	anim_player.play("CHEER", 0.1);

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
	if nav_agent.distance_to_target() > .1 and next_pos != pos:
		look_at(next_pos, Vector3.UP);
		self.rotate_object_local(Vector3.UP, PI);
	var new_velocity: Vector3 = (next_pos - pos).normalized() * move_speed;
	
	if pos.distance_to(next_pos) < .1 and current_anim != "CHEER":
		new_velocity = Vector3.ZERO;
	
	if current_anim == "CHEER" and anim_player.is_playing():
		pass;
	elif new_velocity.length() > 0:
		try_set_anim("WALK");
		anim_player.play(current_anim, 0.1);
	else:
		try_set_anim("IDLE");
		anim_player.play(current_anim, 0.1);
	
	
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
	if name == "CHEER" and model.find_child("AnimationPlayer").is_playing():
		return false;
	if name == current_anim: 
		return false;
	current_anim = name;
	return true;
