extends Node
class_name AdventurerManager;
const D_T = "[ADV_MAN]";

signal new_recruit(id: String);

const _party_names = [
	'Alpha', 'Beta', 'Gamma', 'Delta', 'Epsilon', 'Zeta',
	'Eta', 'Theta', 'Iota', 'Kappa', 'Lambda', 'Mu',
	'Nu', 'Xi', 'Omicron', 'Pi', 'Rho', 'Sigma',
	'Tau', 'Upsilon', 'Phi', 'Chi', 'Psi', 'Omega'
];

var _adventurers : Dictionary = {};
var _parties : Array = [];
var party_edited: Party = null;

# Timers
var TIMER_recruit_refresh : String;


@onready var timers = get_node("%Timers");
@onready var data = get_tree().current_scene; # Getting the root node.

func _ready():
	timers.timer_done.connect(_on_timer_done);
	new_recruit.connect(_on_new_recruit);

func _process(_delta):
	if recruits().size() == 0 and TIMER_recruit_refresh == "":
		TIMER_recruit_refresh = timers.create_timer(60, "When this timer runs out, we will create a new recruit."); #1200
		var adv = data.adv_pool.get_rand_adventurer();
		adv.TIMER_recruit = timers.create_timer(30, str(adv.adv_name(), " dismissal timer.")); #300
		
		_adventurers[adv._unique_id] = adv;
		new_recruit.emit(adv._unique_id);
	pass;

func recruits() -> Array:
	return _adventurers.values().filter(
		func(adv: Adventurer): return adv._status == Adventurer.Status.RECRUIT).map(
		func(adv: Adventurer): return adv._unique_id
	);

func recruited() -> Array:
	return _adventurers.values().filter(
		func(adv: Adventurer): return adv._status != Adventurer.Status.RECRUIT).map(
		func(adv: Adventurer): return adv._unique_id
	);

func recruited_adv() -> Array:
	return _adventurers.values().filter(func(adv: Adventurer): return adv._status != Adventurer.Status.RECRUIT);

func avg_level() -> float:
	var _adv = recruited_adv();
	var avg = 0;
	
	for adv in _adv:
		avg += adv._level;
	
	if _adv.size() > 0:
		avg = avg / float(_adv.size());
	
	return avg;

func _remove_adventurer(adv_id: String):
	if _adventurers.has(adv_id):
		var adv = _adventurers[adv_id];
		data.adv_pool.remove_adventurer(str(adv._family_name, "_", adv._given_name).to_lower());
		_adventurers.erase(adv_id);

func create_party():
	var current_party_names = _parties.map(func(p): return p._title);
	var available_names = _party_names.filter(func(pn): return !current_party_names.has(pn));
	var first_available = available_names[0] if available_names.size() > 0 else "New Party";

	party_edited = Party.new(first_available, [], Party.PartyStatus.IDLE);

func get_party(created: String):
	for party in _parties:
		if party._created_timestamp == created:
			return party;
	return null;

func get_party_by_index(index: int):
	return _parties[index];

func get_available_parties():
	return _parties.filter(func (p):
		return p._status == Party.PartyStatus.IDLE
	);

func get_queued_parties():
	return _parties.filter(func (p):
		return p._status == Party.PartyStatus.QUEUED_FOR_MISSION
	);

func party_can_start_mission(party: Party):
	for id in party._members:
		var adventurer = _adventurers[id] as Adventurer;
		if adventurer._status != Adventurer.Status.IDLE:
			return false;
	return true;

func upsert_party(party: Party):
	for i in _parties.size():
		if _parties[i]._created_timestamp == party._created_timestamp:
			_parties[i] = party;
			return;
	_parties.push_back(party);

func remove_party_member(unique_id: String):
	for i in _parties.size():
		if (_parties[i]._members.has(unique_id)):
			_parties[i]._members.erase(unique_id);
			break;

func remove_empty_parties():
	_parties = _parties.filter(func (p): return p._members.size() > 0);

func get_party_adventurers(party: Party): 
	var adventurers = party._members.map(func(m): return _adventurers[m]);
	return adventurers;

func get_adventurer_party(adventurer_id: String):
	for party in _parties:
		if (party._members.has(adventurer_id)):
			return party;
	return null;

func _on_timer_done(id: String):
	match id:
		TIMER_recruit_refresh:
			TIMER_recruit_refresh = "";
			return;
	
	for adv in _adventurers.values():
		adv._on_timer_done(id);

func _on_new_recruit(id: String):
	var adv = _adventurers[id];
	print(str(D_T, " -> New ", adv.adv_race(), " Recruit <", adv.adv_name(), ", [ID: ", adv._unique_id, "]> Created! "));
