extends Node
class_name TimerContainer;
const D_T = "  [TIMER]";

signal timer_done(id: String);

var _timers : Dictionary = {};
var _timerIndex : int = 0;

func _physics_process(delta):
	var to_delete : Array[String] = [];
	
	for key in _timers:
		var timer = _timers[key];
		if timer.tick(delta):
			print(str(D_T, " -> <", timer._id, "> [", str(timer._value).pad_decimals(2), " / ", timer._length, " seconds] ran out."));
			timer_done.emit(timer._id);
			to_delete.push_back(timer._id);
	
	for id in to_delete:
		_timers.erase(id);
	
	to_delete.clear();
	pass;

func create_timer(length: float, description: String = "", startOnCreate: bool = true) -> String:
	var id = _create_id();
	_timers[id] = InternalTimer.new(id, length, description, startOnCreate);
	print(str(D_T, " -> <", id, "> :: ", "(PAUSED) " if !startOnCreate else "", "[", _timers[id].get_timer_text(),"] Created."));
	return id;

func start_timer(id: String):
	_timers[id]._started = true;

func pause_timer(id: String):
	_timers[id]._started = false;

func delete_timer(id: String):
	_timers.erase(id);
	pass;

func _create_id() -> String:
	var id = str(_timerIndex,"__timer");
	_timerIndex = (_timerIndex + 100) % 99999;
	return Marshalls.utf8_to_base64(id);

func _get_timers() -> Array:
	return _timers.values();

class InternalTimer:
	var _id : String;
	var _length : float;
	var _value : float;
	var _description : String;
	var _mark_delete : bool;
	var _started : bool;
	
	func _init(id: String, length: float, description: String = "", startOnCreate: bool = true):
		_id = id;
		_length = length;
		_value = 0;
		_mark_delete = false;
		_description = description;
		_started = startOnCreate;
		pass;
	
	func tick(delta: float) -> bool:
		if !_started:
			return false;
		_value = clampf(_value + delta, 0, _length);
		_mark_delete = (_value == _length);
		return _mark_delete;
	
	func get_progress01() -> float:
		return _value / _length;
	
	func get_progress_text() -> String:
		return str(get_progress01() * 100, "%").pad_decimals(0);
	
	func get_timer_text() -> String:
		var inv_value : float = _length - _value;
		var hours : float = inv_value / 3600;
		var hours_floored = floori(hours);
		var minutes : float = (hours - hours_floored) * 60;
		var minutes_floored = floori(minutes);
		var seconds : float = (minutes - minutes_floored) * 60;
		var seconds_rounded = roundi(seconds);
		
		return str("%02d" % hours_floored, ":", "%02d" % minutes_floored, ":", "%02d" % seconds_rounded);
	
	func get_timer_seconds() -> float:
		return floori(_length - _value);
