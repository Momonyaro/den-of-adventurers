extends Node;
class_name RequestManager;

@onready var request_data: Array = ResourceLoader.load("res://Resources/Requests/RequestData.tres").data;
@onready var adv_manager : AdventurerManager = get_node("/root/Root/Adventurers");
@onready var game_manager: GameManager = get_node("/root/Root/Game");
@onready var notifications = get_node("/root/Root/UI/Notifications");
@onready var timers: TimerContainer = get_node("%Timers");

var _active_requests: Dictionary = {}; 
var _completed_requests: Array = []; 
var _initialized = false;

func _ready():
	timers.timer_done.connect(_on_timer_done);

func _process(_delta):
	if !_initialized:
		return;

	var queued_parties = adv_manager.get_queued_parties() as Array[Party];
	for party in queued_parties:
		if adv_manager.party_can_start_mission(party):
			if _active_requests.has(party._current_request_id):
				var _active_request = _active_requests[party._current_request_id];
				var _request = _try_get_request(party._current_request_id)[1];
				timers.start_timer(_active_request.TIMER_go_to);
				party._status = Party.PartyStatus.GOING_TO_MISSION;
				notifications.create_notification(
					ResourceLoader.load('res://Textures/Icons/exit.png') as Texture2D,
					str("Party '", party._title, "' are now setting off towards ", _request._location, " for their mission!"),
					func(): pass,
					30
				);

func get_requests() -> Dictionary:
	var to_return: Dictionary = {
		'Active': [],
		'Available': [],
		'Completed': []
	};
	var _active_ids = _active_requests.keys();
	var _completed_ids = _completed_requests;
	var _guild_data = game_manager.guild_data;

	var requests = request_data.map(func (d): return RequestItem.new(d)); # This won't filter out unavailable requests...
	requests = requests.filter(func (r): return _validate_request(r, _completed_requests, _guild_data.guild_level, _guild_data.guildhall_tier));

	for request in requests:
		if _completed_ids.has(request._id):
			request._is_completed = true;
			to_return['Completed'].push_back(request);
		elif _active_ids.has(request._id):
			request._is_active = true;
			to_return['Active'].push_back(request);
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

func _validate_request(request: RequestItem, completed: Array, guild_level: int, guild_tier: int) -> bool:
	var guildLevelRange = request._guild_level_range;
	var guildTierRange = request._guild_tier_range;

	if guildLevelRange[1] > 0:
		if guild_level < guildLevelRange[0] || guild_level >= guildLevelRange[1]:
			return false;

	if guildTierRange[1] > 0:
		if guild_tier < guildTierRange[0] || guild_tier >= guildTierRange[1]:
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

func complete_request(request: RequestItem, party: Party):
	# Add request guild xp to guild
	var guild_xp_reward = request._rewards.filter(func (r): return r.contains('g_xp'));
	guild_xp_reward = guild_xp_reward[0] if guild_xp_reward.size() > 0 else 'g_xp$0';
	var split = guild_xp_reward.split('$');
	var guild_xp = int(split[1]);
	# Add gold to guild_balance
	var gold_reward = request._rewards.filter(func (r): return r.contains('gold'));
	gold_reward = gold_reward[0] if gold_reward.size() > 0 else 'gold$0';
	var gold_split = gold_reward.split('$');
	var gold = int(gold_split[1]);

	var members = adv_manager.get_party_adventurers(party);
	for member in members:
		member.add_xp(guild_xp * 0.5);

	game_manager.guild_data.add_xp(guild_xp);
	game_manager.guild_data.guild_balance += gold;

	_active_requests.erase(request._id);
	_completed_requests.push_back(request._id);
	party._current_request_id = "";
	party._status = Party.PartyStatus.IDLE;

func get_requirement(type: String, value: int) -> Requirement:
	match (type):
		"PartyMembersAbove": return PartyMembersAbove.new(value);
		"PartyMembersEqual": return PartyMembersEquals.new(value);
		"NoDemiHumans": return NoDemiHumans.new();
		"AtkScoreAbove": return PartyAtkScoreAbove.new(value);
		"AtkScoreBelow": return PartyAtkScoreBelow.new(value);
		"SupScoreAbove": return PartySupScoreAbove.new(value);
		"SupScoreBelow": return PartySupScoreBelow.new(value);
		_: return null;

func _on_timer_done(id: String):
	for key in _active_requests.keys():
		var req = _active_requests[key];
		if req == null:
			continue;

		match id:
			req.TIMER_go_to:
				var matches = adv_manager.try_get_party_with_request(key);
				req.TIMER_go_to = "";
				if req.TIMER_duration != '':
					timers.start_timer(req.TIMER_duration);
					for p in matches:
						p._status = Party.PartyStatus.ON_MISSION;
				else:
					timers.start_timer(req.TIMER_go_home);
					for p in matches:
						p._status = Party.PartyStatus.RETURNING_FROM_MISSION;
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
				
				notifications.create_notification(
					ResourceLoader.load('res://Textures/Icons/mail.png') as Texture2D,
					"A request is ready to be turned in!",
					func(): pass,
					30
				);
				req.TIMER_go_home = "";

	pass;

func _on_save_game(save_buffer: Dictionary):
	save_buffer['completed_requests'] = _completed_requests;
	save_buffer['active_requests'] = _active_requests.values().map(func (ar): return ar.to_dict());
	pass # Replace with function body.

func _on_load_game(loaded_data: Dictionary):
	_completed_requests = loaded_data['completed_requests'] as Array[String];
	_active_requests.clear();

	var has_unredeemed = false;

	for item in loaded_data['active_requests'].map(func (ard): return ActiveRequestItem.from_dict(ard)):
		_active_requests[item._id] = item;
		if _active_requests[item._id].TIMER_go_home == "":
			has_unredeemed = true;
	
	# Find requests that you can turn in and create a notification to tell the player.
	if has_unredeemed:
		await get_tree().create_timer(0.1).timeout;
		notifications.create_notification(
			ResourceLoader.load('res://Textures/Icons/exclamation.png') as Texture2D,
			"There are requests ready to be turned in!",
			func(): pass,
			30
		);

	_initialized = true;
	pass # Replace with function body.


class RequestItem:
	var _title: String = "";
	var _id: String = "";
	var _requestor: String = "";
	var _body: String = "";
	var _location: String = "";
	var _duration: float = 0;
	var _guild_tier_range: Array = [0, 0];
	var _guild_level_range: Array = [0, 0];
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
		_guild_level_range = dict['GuildLevelRange'] if dict.has('GuildLevelRange') else _guild_level_range;
		_previous_requests = dict['PrevRequests'] if dict.has('PrevRequests') else [];
		_requirements = dict['Requirements'] if dict.has('Requirements') else [];
		_rewards = dict['Rewards'] if dict.has('Rewards') else [];

class ActiveRequestItem:
	var _id: String;
	var TIMER_go_to: String;
	var TIMER_duration: String;
	var TIMER_go_home: String;

	func _init(id: String, go_to_time: float = 0, duration_time: float = 0, go_home_time: float = 0, timers: TimerContainer = null):
		_id = id;
		if timers != null:
			TIMER_go_to = timers.create_timer(go_to_time, str('travel to request: ', id), false);
			TIMER_duration = timers.create_timer(duration_time, str('duration of request: ', id), false) if duration_time > 0 else "";
			TIMER_go_home = timers.create_timer(go_home_time, str('returning from request: ', id), false);
	
	func to_dict() -> Dictionary:
		return {
			'_id': _id,
			'TIMER_go_to': TIMER_go_to,
			'TIMER_duration': TIMER_duration,
			'TIMER_go_home': TIMER_go_home
		};
	
	static func from_dict(dict: Dictionary) -> ActiveRequestItem:
		var item = ActiveRequestItem.new(dict['_id']);
		item.TIMER_go_to    = dict['TIMER_go_to'];
		item.TIMER_duration = dict['TIMER_duration'];
		item.TIMER_go_home  = dict['TIMER_go_home'];
		return item;
