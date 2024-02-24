extends Node;
class_name RequestManager;

@onready var request_data: Array = ResourceLoader.load("res://Resources/Requests/RequestData.tres").data;
@onready var adv_manager : AdventurerManager = get_node("/root/Root/Adventurers");
@onready var timers: TimerContainer = get_node("%Timers");

var _active_requests: Dictionary = {}; 
var _completed_requests: Array[String] = []; 

func _ready():
	timers.timer_done.connect(_on_timer_done);
	var items = get_requests()['Available'];

	for item in items:
		print(item._title, " :: ", item._id);
		print(item._requestor, " -> ", item._body);
		print("Location: ", item._location);
		print("Requirements: [", ', '.join(item._requirements), "]");
		print("Rewards: ", ', '.join(item._rewards));
		print();

func _process(delta):
	var queued_parties = adv_manager.get_queued_parties() as Array[Party];
	for party in queued_parties:
		if adv_manager.party_can_start_mission(party):
			var _request = _active_requests[party._current_request_id];
			timers.start_timer(_request.TIMER_go_to);
			party._status = Party.PartyStatus.GOING_TO_MISSION;

func get_requests() -> Dictionary:
	var to_return: Dictionary = {
		'Active': [],
		'Available': [],
		'Completed': []
	};
	var _active_ids = _active_requests.keys();
	var _completed_ids = _completed_requests;

	var requests = request_data.map(func (d): return RequestItem.new(d)); # This won't filter out unavailable requests...
	requests = requests.filter(func (r): return _validate_request(r, _completed_requests, 1));

	for request in requests:
		if _active_ids.has(request._id):
			request._is_active = true;
			to_return['Active'].push_back(request);
		elif _completed_ids.has(request._id):
			request._is_completed = true;
			to_return['Completed'].push_back(request);
		else:
			to_return['Available'].push_back(request);
	
	return to_return;

func _try_get_request(id: String) -> Array: # return (success, result)
	var items = request_data.filter(func (i): return i['ID'] == id)
	if items.size() > 0:
		var item = RequestItem.new(items[0]);
		var is_active = _active_requests.keys().has(item._id);
		var is_complete = _completed_requests.has(item._id);
		item._is_active = is_active;
		item._is_completed = is_complete;

		return [true, item];
	else:
		return [false, null]

func _validate_request(request: RequestItem, completed: Array, guildTier: int) -> bool:
	var guildRange = request._guild_tier_range;

	if guildRange[1] > 0:
		if guildTier < guildRange[0] || guildTier >= guildRange[1]:
			return false;

	var prerequisites = request._previous_requests;
	for req in prerequisites:
		if !completed.has(req):
			return false;

	return true;

func accept_request(request: RequestItem, party: Party, go_to_time: float, duration: float, go_home_time: float):
	_active_requests[request._id] = ActiveRequestItem.new(request._id, go_to_time, duration, go_home_time, timers);
	party._current_request_id = request._id;
	party._status = Party.PartyStatus.QUEUED_FOR_MISSION;

func get_requirement(type: String, value: int) -> Requirement:
	match (type):
		"PartyMembersAbove": return PartyMembersAbove.new(value);
		"NoDemiHumans": return NoDemiHumans.new();
		_: return null;

func _on_timer_done(id: String):
	for key in _active_requests.keys():
		var req = _active_requests[key];

		match id:
			req.TIMER_go_to:
				var matches = adv_manager.try_get_party_with_request(key);
				for p in matches:
					p._status = Party.PartyStatus.ON_MISSION;
				req.TIMER_go_to = "";
				timers.start_timer(req.TIMER_duration);
			req.TIMER_duration:
				var matches = adv_manager.try_get_party_with_request(key);
				for p in matches:
					p._status = Party.PartyStatus.RETURNING_FROM_MISSION;
				req.TIMER_duration = "";
				timers.start_timer(req.TIMER_go_home);
			req.TIMER_go_home:
				var matches = adv_manager.try_get_party_with_request(key);
				for p in matches:
					p._status = Party.PartyStatus.RETURNED;
				req.TIMER_go_home = "";

	pass;

class RequestItem:
	var _title: String = "";
	var _id: String = "";
	var _requestor: String = "";
	var _body: String = "";
	var _location: String = "";
	var _duration: float = 0;
	var _guild_tier_range: Array = [0, 0];
	var _previous_requests: Array = [];
	var _requirements: Array = [];
	var _rewards: Array = [];
	var _is_active: bool = false;
	var _is_completed: bool = false;

	func _init(dict: Dictionary):
		_title = dict['Title'] if dict.has('Title') else '';
		_id = dict['ID'] if dict.has('ID') else '';
		_requestor = dict['Requestor'] if dict.has('Requestor') else '';
		_body = dict['Body'] if dict.has('Body') else '';
		_location = dict['Location'] if dict.has('Location') else '';
		_duration = dict['Duration'] if dict.has('Duration') else 0;
		_guild_tier_range = dict['GuildTierRange'] if dict.has('GuildTierRange') else _guild_tier_range;
		_previous_requests = dict['PrevRequests'] if dict.has('PrevRequests') else [];
		_requirements = dict['Requirements'] if dict.has('Requirements') else [];
		_rewards = dict['Rewards'] if dict.has('Rewards') else [];

class ActiveRequestItem:
	var _id: String;
	var TIMER_go_to: String;
	var TIMER_duration: String;
	var TIMER_go_home: String;

	func _init(id: String, go_to_time: float, duration_time: float, go_home_time: float, timers: TimerContainer):
		_id = id;
		TIMER_go_to = timers.create_timer(go_to_time, '', false);
		TIMER_duration = timers.create_timer(duration_time, '', false);
		TIMER_go_home = timers.create_timer(go_home_time, '', false);
