extends Node
class_name AdventurerManager;
var _adventurers : Dictionary = {};

# Timers
var TIMER_recruit_refresh : String;


@onready var timers = get_node("%Timers");
@onready var data = get_tree().current_scene; # Getting the root node.

func _ready():
	timers.timer_done.connect(_on_timer_done);

func _process(delta):
	if recruits().size() == 0 and TIMER_recruit_refresh == "":
		TIMER_recruit_refresh = timers.create_timer(1200);
		var adv = data.adv_pool.get_rand_adventurer();
		adv.TIMER_recruit = timers.create_timer(300);
		_adventurers[adv._unique_id] = adv;
	pass;

func recruits() -> Array[String]:
	var to_return : Array[String];
	for adv in _adventurers.values():
		if adv._status == Adventurer.Status.RECRUIT:
			to_return.push_back(adv._unique_id);
	return to_return;

func _on_timer_done(id: String):
	match id:
		TIMER_recruit_refresh:
			TIMER_recruit_refresh = "";
			return;
	
	for adv in _adventurers.values():
		adv._on_timer_done(id);
