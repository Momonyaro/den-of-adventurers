extends Node
class_name AdventurerManager;
const D_T = "[ADV_MAN]";

signal new_recruit(id: String);

var _adventurers : Dictionary = {};

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
		avg = avg / _adv.size();
	
	return avg;

func _remove_adventurer(adv_id: String):
	if _adventurers.has(adv_id):
		var adv = _adventurers[adv_id];
		data.adv_pool.remove_adventurer(str(adv._family_name, "_", adv._given_name).to_lower());
		_adventurers.erase(adv_id);

func _on_timer_done(id: String):
	match id:
		TIMER_recruit_refresh:
			TIMER_recruit_refresh = "";
			return;
	
	for adv in _adventurers.values():
		adv._on_timer_done(id);

func _on_new_recruit(id: String):
	var adv = _adventurers[id];
	print(str(D_T, " -> New ", adv.adv_race(), " Recruit \"", adv.adv_name(), "\" [", adv._unique_id, "] Created! "));
