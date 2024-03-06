extends Node
class_name Party

enum PartyStatus {IDLE, QUEUED_FOR_MISSION, GOING_TO_MISSION, ON_MISSION, RETURNING_FROM_MISSION, RETURNED}

var _title : String = "";
var _created_timestamp : String = "";
var _members : Array = []
var _status : PartyStatus = PartyStatus.IDLE;
var _current_request_id : String = "";

func _init(title: String, members: Array, status: PartyStatus = PartyStatus.IDLE, current_request_id: String = ""):
	_title = title;
	_created_timestamp = Time.get_datetime_string_from_unix_time(floori(Time.get_unix_time_from_system()));
	_members = members;
	_status = status;
	_current_request_id = current_request_id;

static func copy(party: Party):
	var new_party = Party.new(party._title, party._members, party._status);
	new_party._created_timestamp = party._created_timestamp;
	new_party._current_request_id = party._current_request_id;
	return new_party;

func get_atk_score() -> int:
	var score : int = 0;
	for i in _members:
		if i == null: continue;
		score += i._level;
		
	return score;

func get_sup_score() -> int:
	var score : int = 0;
	for i in _members:
		if i == null: continue;
		score += i._level;
		
	return score;

func to_dict() -> Dictionary:
	return {
		'_title': _title,
		'_created_timestamp': _created_timestamp,
		'_members': _members,
		'_status': _status,
		'_current_request_id': _current_request_id
	};

static func from_dict(dict: Dictionary) -> Party:
	var p = Party.new(
		dict['_title'], 
		dict['_members'], 
		dict['_status'] as PartyStatus, 
		dict['_current_request_id']
	);

	p._created_timestamp = dict['_created_timestamp'];
	return p;

# Party score calculation:
# - It takes into account: level, stats(?) and items.
# - It would probably just be easier to do something like score = (level * l_mod) + (stats_score + s_mod) + (item_score * i_mod)
# - The _mod values in this case is just to be able to tweak the importance of some of these factors. (e.g. Item score modifier will likely be lower than level modifier)
# - The part we need to figure out is how the different stats factor in (or if they even do, I don't really see a way of using it...)
# - Probably just add the class as a variable instead for the level factor (level * class_mod * l_mod) => final value.
# - This method could be nice since it could make support classes decrease total party score but then instead lessen the provisions needed or something.
