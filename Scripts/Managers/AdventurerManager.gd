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

func _process(delta):
	if recruits().size() == 0 and TIMER_recruit_refresh == "":
		TIMER_recruit_refresh = timers.create_timer(60); #1200
		var adv = data.adv_pool.get_rand_adventurer();
		adv.TIMER_recruit = timers.create_timer(30); #300
		
		_adventurers[adv._unique_id] = adv;
		new_recruit.emit(adv._unique_id);
	pass;

func recruits() -> Array:
	return _adventurers.values().filter(
		func(adv: Adventurer): return adv._status == Adventurer.Status.RECRUIT).map(
		func(adv: Adventurer): return adv._unique_id
	);

func _on_timer_done(id: String):
	match id:
		TIMER_recruit_refresh:
			TIMER_recruit_refresh = "";
			return;
	
	for adv in _adventurers.values():
		adv._on_timer_done(id);

func _on_new_recruit(id: String):
	var adv = _adventurers[id];
	print(str(D_T, " -> New ", adv.adv_race(), " Recruit \"", adv.adv_name(), "\" Created! "));
