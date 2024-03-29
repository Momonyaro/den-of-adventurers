extends Control

#id should be 'WINDOW:[INSTRUCTION]:[ID]' e.g.: 'WINDOW:OPEN:SYS_INFO'
const OPEN_ANIM_LENGTH = 0.26;

@export var prompt: Node = null;
@export var window_base: PackedScene = preload("res://Prefabs/UI/windows/window_base.tscn");
var preview_rect: PackedScene = preload("res://Prefabs/UI/windows/preview_rect.tscn");
@onready var _composer: Node = get_node("/root/Root/UI/Composer");

var windows = []; # store id and ref to node.

var tweens = [];
var impostor: Node = null;
var impostor_offset: Vector2 = Vector2.ZERO;
var impostor_ref: String;

func _process(delta):
	for window in windows:
		var win = window[1];
		var win_box = win.get_child(0);
		var clamped_pos = _clamp_impostor_pos(win.global_position, win_box.get_global_rect().size);
		win.global_position = clamped_pos;

	for tween in tweens:
		if tween[4] == null:
			print("window ", tween[6], " was forced close during tween, exiting!");
			tween[5] = true;
			tween[3].queue_free();
		else:
			var progress = tween[2] / OPEN_ANIM_LENGTH;
			var start_rect = Rect2(tween[1], Vector2(0, 0));
			var end_rect = tween[4].get_child(0).get_global_rect();

			var lerped_rect = _lerp_rect(start_rect, end_rect, progress);
			tween[3].set_position(lerped_rect.position + Vector2(0, -24));
			tween[3].set_size(lerped_rect.size);

			tween[2] = min(tween[2] + delta, OPEN_ANIM_LENGTH);
			if tween[2] == OPEN_ANIM_LENGTH:
				tween[3].queue_free();
				tween[4].visible = true;
				tween[5] = true;

	for i in tweens.size():
		if tweens[i][5] == true:
			tweens.remove_at(i);
			break;

	if Input.is_action_just_released("click") && impostor != null:
		_move_window_to(impostor_ref, impostor.global_position);
	elif impostor != null:
		impostor.global_position = _clamp_impostor_pos(get_global_mouse_position() + impostor_offset, impostor.get_global_rect().size);
		
	pass;

func process_command(command: String, start_pos: Vector2 = Vector2()):
	var split = command.split(':');
	if split[0] != "WINDOW": return;
	var set_size = null;
	if split.size() > 3:
		set_size = Vector2(int(split[3]), int(split[4]))

	match (split[1]):
		"OPEN": open_window(split[2], start_pos, null);
		"RESET": reset_window(split[2], start_pos, set_size);
		"CLOSE": close_window(split[2]);
		"FORCE_CLOSE": close_window(split[2], true);


func open_window(ref: String, start_pos: Vector2, window_pos):
	if _has_instance(ref): return;
	var window_data = WindowData.get_window_data(ref);
	if window_data[0] == null || window_data[1] == null: 
		print("Failed to find window data for key: ", ref);
		return;
	
	var rect = get_global_rect();
	var center = (rect.position + rect.size) / 2;
	var instance = window_base.instantiate();
	self.add_child(instance);
	instance.set_position(center);

	instance.populate(window_data[0], window_data[1], window_pos);
	instance._manager = self;
	windows.push_front([ref, instance]);
	_animate_opening(start_pos, instance, ref);
	_composer.play("res://Audio/SFX/UI/maximize_006.ogg");
	_sort_windows();

func reset_window(ref: String, start_pos: Vector2, window_pos):
	var window = _get_instance(ref) if _has_instance(ref) else null;
	var _window_pos = window_pos;
	if window != null:
		_window_pos = window[1].position;
	
	close_window(ref);
	open_window(ref, start_pos, _window_pos);

func close_window(ref: String, force: bool = false):
	var window = _get_instance(ref) if _has_instance(ref) else null;
	if window == null: 
		return;

	#check if it's tweening
	var active_tweens = tweens.map(func (t): return t[6]);
	if active_tweens.has(ref) && !force:
		return;

	_composer.play("res://Audio/SFX/UI/minimize_008.ogg");
	window[1].queue_free();
	_del_instance(ref);
	pass;

func _animate_opening(start_pos: Vector2, window_ref: Control, ref: String):
	window_ref.visible = false;
	var instance = preview_rect.instantiate();
	self.add_child(instance);
	var _timer = 0;
	tweens.push_back(["OPEN", start_pos, _timer, instance, window_ref, false, ref]);

	pass;

func _lerp_rect(start: Rect2, end: Rect2, t: float):
	var clamped_t = clamp(t, 0, 1);
	var clamped_pos = lerp(start.position, end.position, clamped_t);
	var clamped_size = lerp(start.size, end.size, clamped_t);

	return Rect2(clamped_pos, clamped_size);

func _has_instance(ref: String) -> bool:
	for window in windows:
		if window[0] == ref:
			return true;
	return false;

func _get_instance(ref: String):
	for window in windows:
		if window[0] == ref:
			return window;
	return null;

func _del_instance(ref: String):
	for i in windows.size():
		if windows[i][0] == ref:
			windows.remove_at(i);
			return;

func _move_window_to(ref: String, global_pos: Vector2):
	var window: Array = _get_instance(ref);
	window[1].global_position = global_pos;
	impostor.queue_free();
	impostor = null;
	impostor_offset = Vector2.ZERO;
	impostor_ref = "";
	windows = windows.filter(func (w): return w[0] != ref);
	windows.push_front(window);
	_sort_windows();

func _sort_windows():
	var _max = windows.size();

	for i in _max:
		var reverse_i = _max - 1 - i;
		windows[reverse_i][1].move_to_front();
	
	for i in tweens.size():
		if tweens[i][5]:
			return;
		else:
			tweens[i][3].move_to_front();

	if impostor != null:
		impostor.move_to_front();


func _clamp_impostor_pos(_pos: Vector2, _size: Vector2) -> Vector2:
	var glo_pos = self.global_position;
	var glo_size = self.get_global_rect().size;
	if _pos.x < glo_pos.x: _pos.x = glo_pos.x;
	if _pos.y < glo_pos.y: _pos.y = glo_pos.y;

	if _pos.x + _size.x >= glo_pos.x + glo_size.x: _pos.x = glo_pos.x + glo_size.x - _size.x;
	if _pos.y + _size.y >= glo_pos.y + glo_size.y: _pos.y = glo_pos.y + glo_size.y - _size.y;
	return _pos;

func create_prompt(title: String, warning: String, icon: String, ok_option: String, no_option: String, ok_callback: Callable):
	
	var item = {
		'prompt_title': title,
		'prompt_warning': warning,
		'prompt_icon': icon,
		'ok_option': ok_option,
		'ok_callback': ok_callback,
		'no_option': no_option,
	};
	
	prompt.set_prompt.emit(item);

func _on_grab_header(ref: String, inital_pos: Vector2):
	var _instance: Array = _get_instance(ref);
	impostor = preview_rect.instantiate();
	self.add_child(impostor);
	impostor_offset = _instance[1].global_position - inital_pos;

	impostor.set_size(_instance[1].get_child(0).get_global_rect().size);
	impostor_ref = ref;

	#when clicking a window header, spawn an impostor that follows the mouse.
	pass;
