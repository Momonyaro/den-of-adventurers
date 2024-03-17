class_name AgentNavigation;

var _start_pos : Vector3 = Vector3.ZERO;
var _target_pos : Vector3 = Vector3.ZERO;
var _self = null;
var _move_speed : float = 0;
var movement_delta: float = 0;

var is_moving = false;

func _init(node: Node3D, move_speed: float):
	_start_pos = node.global_transform.origin;
	_target_pos = _start_pos;
	_move_speed = move_speed;
	
	_self = node;

func get_random_pos() -> Vector3:
	var rand_x = randf_range(-3, 3);
	var rand_z = randf_range(-3, 3);
	return _start_pos + Vector3(rand_x, 0, rand_z);

func nav_finished() -> bool:
	return nav_agent().is_navigation_finished();

func at_target() -> bool:
	var origin = _self.global_transform.origin;
	var end = nav_agent().get_final_position();
	return origin.distance_to(end) < 0.1; 

func update_target_pos(target_pos):
	_target_pos = target_pos;
	nav_agent().target_position = target_pos;
	is_moving = true;

func cancel_nav():
	nav_agent().target_position = nav_agent().get_parent().global_position;
	is_moving = false;

func tick_movement(node: Node, delta: float):
	var origin = node.global_transform.origin;
	
	movement_delta = _move_speed * delta;
	var next_path_position: Vector3 = nav_agent().get_next_path_position()
	var next_flat_position = Vector3(next_path_position.x, origin.y, next_path_position.z);
	var new_velocity: Vector3 = origin.direction_to(next_path_position) * movement_delta
	if nav_agent().avoidance_enabled:
		nav_agent().set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)

	if (_self.get_child(2).distance_to_target() > .1 and next_path_position != origin):
		node.look_at(next_flat_position, Vector3.UP);
		node.rotate_object_local(Vector3.UP, PI);
	
	is_moving = !at_target();
	nav_agent().debug_path_custom_color = Color.GREEN if !is_moving else Color.RED;

func _on_velocity_computed(safe_velocity: Vector3) -> void:
	_self.global_position = _self.global_position.move_toward(_self.global_position + safe_velocity, movement_delta)

func nav_agent() -> NavigationAgent3D:
	return _self.get_child(2) as NavigationAgent3D;
