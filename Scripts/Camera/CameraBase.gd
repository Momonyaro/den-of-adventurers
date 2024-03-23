extends Node3D

@export var camera_pan_speed: float = 12;
@export var camera_zoom_speed: float = 3;

@export var camera_far_dist: float = 6;
@export var camera_far_height: float = 8;
@export var camera_near_dist: float = 4;
@export var camera_near_height: float = 2;

@export_group("Camera Region")
@export var left: float = 0;
@export var top: float = 0;
@export var right: float = 0;
@export var bottom: float = 0;

@export_group("Debug")
@export var debug_draw = false;

@onready var camera_foot = $CAMERA_FOOT;
@onready var camera_focus = $CAMERA_FOOT/CAMERA_FOCUS;
@onready var camera = $SCENE_CAM;
var draw_camera_foot = null;
var camera_foot_offset = Vector3.ZERO;
var last_cam_pos = Vector3.ZERO;
var camera_zoom: float = 0;

func _ready():
	last_cam_pos = camera.global_position;
	camera_foot_offset = camera.global_position - camera_foot.global_position;
	if debug_draw:
		var draw_bounds = Draw3D.new();
		add_child(draw_bounds);
		draw_bounds.draw_line(debug_draw_bounds(), Color.RED);

		draw_camera_foot = Draw3D.new();
		add_child(draw_camera_foot);

func _process(delta):
	# Move / Pan Camera Foot
	var move_vec = Vector3.ZERO;
	if Input.is_action_pressed("move_up"):
		move_vec += Vector3.FORWARD;
	if Input.is_action_pressed("move_down"):
		move_vec += Vector3.BACK;
	if Input.is_action_pressed("move_right"):
		move_vec += Vector3.RIGHT;
	if Input.is_action_pressed("move_left"):
		move_vec += Vector3.LEFT;

	# Zoom Camera
	if Input.is_action_just_released("scroll_out"):
		camera_zoom = clampf(camera_zoom + (-camera_zoom_speed * delta), 0, 1);
	elif Input.is_action_just_released("scroll_in"):
		camera_zoom = clampf(camera_zoom + (camera_zoom_speed * delta), 0, 1);

	camera_foot.translate(move_vec.normalized() * camera_pan_speed * delta);
	camera_foot.global_position = clamp_pos_to_region(camera_foot.global_position);

	update_camera_pos();
	update_camera_rot();

	if debug_draw and draw_camera_foot != null:
		draw_camera_foot.clear();
		draw_camera_foot.draw_line(debug_draw_camera_foot(), Color.GREEN);

func update_camera_pos():
	var new_cam_pos = (camera_foot.global_position + calculate_zoom());

	var lerp_cam_pos = last_cam_pos.lerp(new_cam_pos, .75);
	camera.global_position = lerp_cam_pos;
	last_cam_pos = lerp_cam_pos;

func update_camera_rot():
	camera.look_at(camera_focus.global_position);

func calculate_zoom() -> Vector3:
	var camera_height = lerpf(camera_far_height, camera_near_height, _ease_out_sine(camera_zoom));
	var camera_dist = lerpf(camera_far_dist, camera_near_dist, _ease_out_sine(camera_zoom));

	return Vector3(0, camera_height, camera_dist);

func clamp_pos_to_region(pos: Vector3) -> Vector3:
	var pos_ignore_y = Vector2(pos.x, pos.z);
	var result_pos = Vector3(0, pos.y, 0);
	var ao = self.global_position;

	var l_ao = _get_offset(ao, -left);
	var r_ao = _get_offset(ao, right);
	var d_ao = _get_offset(ao, 0, -bottom);
	var u_ao = _get_offset(ao, 0, top);

	result_pos.x = l_ao.x if pos_ignore_y.x < l_ao.x else r_ao.x if pos_ignore_y.x >= r_ao.x else pos_ignore_y.x;
	result_pos.z = d_ao.z if pos_ignore_y.y < d_ao.z else u_ao.z if pos_ignore_y.y >= u_ao.z else pos_ignore_y.y;

	return result_pos;

func debug_draw_bounds() -> Array:
	var pos = self.global_position;
	var ground_offset = 0.25;

	return([
		pos + Vector3(-left, ground_offset, -bottom),
		pos + Vector3(right, ground_offset, -bottom),
		pos + Vector3(right, ground_offset, top),
		pos + Vector3(-left, ground_offset, top),
		pos + Vector3(-left, ground_offset, -bottom)
	]);

func debug_draw_camera_foot() -> Array:
	var pos = camera_foot.global_position;
	var ground_offset = 0.3;
	var size = 0.1;

	return([
		pos + Vector3(-size, ground_offset, -size),
		pos + Vector3(size, ground_offset, -size),
		pos + Vector3(size, ground_offset, size),
		pos + Vector3(-size, ground_offset, size),
		pos + Vector3(-size, ground_offset, -size)
	]);

func _get_offset(vec3: Vector3, xOffset: float = 0, zOffset: float = 0) -> Vector3:
	return Vector3(vec3.x + xOffset, vec3.y, vec3.z + zOffset)

func _ease_out_quart(x: float) -> float:
	return 1 - pow(1 - x, 4);

func _ease_in_sine(x: float) -> float:
	return 1.0 - cos((x * PI) / 2.0);

func _ease_out_sine(x: float) -> float:
	return sin((x * PI) / 2.0);