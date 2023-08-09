extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D;
@onready var model = $little_guy;
@onready var nav_target_pos = global_transform.origin;
@onready var start_point = global_transform.origin;

@export var move_speed = 5.0;
@export var idle_time = 2.5;
var timer = 0;
var current_anim = "WALK";

func _process(delta):
	if nav_agent.is_navigation_finished():
		timer += delta;
		if timer >= idle_time:
			timer = 0;
			update_target_pos(get_random_pos());
	elif current_anim != "WALK":
		current_anim = "WALK";
		model.find_child("AnimationPlayer").play("WALK", 0.2);

func _physics_process(delta):
	var pos = global_transform.origin;
	var next_pos = nav_agent.get_next_path_position();
	if nav_agent.distance_to_target() > .1:
		look_at(next_pos, Vector3.UP);
		self.rotate_object_local(Vector3.UP, PI);
	var new_velocity = (next_pos - pos).normalized() * move_speed;
	
	if pos.distance_to(next_pos) < .2:
		if current_anim != "IDLE":
			current_anim = "IDLE";
			model.find_child("AnimationPlayer").play("IDLE", 0.2);
		new_velocity = Vector3.ZERO;
	
	velocity = new_velocity;
	move_and_slide();

func update_target_pos(target_pos):
	nav_target_pos = target_pos;
	nav_agent.target_position = target_pos;

func get_random_pos() -> Vector3:
	var rand_x = randf_range(-2, 2);
	var rand_z = randf_range(-2, 2);
	var rand_point = start_point + Vector3(rand_x, 0, rand_z);
	
	return rand_point;
