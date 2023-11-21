class_name AgentNavigation;

var _start_pos : Vector3 = Vector3.ZERO;
var _target_pos : Vector3 = Vector3.ZERO;
var _nav_agent : NavigationAgent3D = null;
var _move_speed : float = 0;

var is_moving = false;

func _init(start_pos: Vector3, nav_agent: NavigationAgent3D, move_speed: float):
	_start_pos = start_pos;
	_target_pos = start_pos;
	_nav_agent = nav_agent;
	_move_speed = move_speed;

func get_random_pos() -> Vector3:
	var rand_x = randf_range(-3, 3);
	var rand_z = randf_range(-3, 3);
	return _start_pos + Vector3(rand_x, 0, rand_z);

func nav_finished() -> bool:
	return _nav_agent.is_navigation_finished();

func update_target_pos(target_pos):
	_target_pos = target_pos;
	_nav_agent.target_position = target_pos;
	is_moving = true;

func cancel_nav():
	_nav_agent.target_position = _nav_agent.get_parent().global_position;
	is_moving = false;

func tick_movement(node: Node):
	var origin = node.global_transform.origin;
	var next_pos = _nav_agent.get_next_path_position();
	var flat_pos = Vector3(next_pos.x, origin.y, next_pos.z);
	if (_nav_agent.distance_to_target() > .1 and next_pos != origin):
		node.look_at(flat_pos, Vector3.UP);
		node.rotate_object_local(Vector3.UP, PI);
	var new_velocity: Vector3 = (next_pos - origin).normalized() * _move_speed;
	
	if origin.distance_to(next_pos) < .1:
		new_velocity = Vector3.ZERO;
	
	if new_velocity.length() > 0:
		is_moving = true;
	else:
		is_moving = false;
		
	node.velocity = new_velocity;
	node.move_and_slide();
