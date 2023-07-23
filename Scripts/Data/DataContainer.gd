extends Node

var name_pool : NamePool;
var adv_pool : AdventurerPool;
var initialized = false;

var observed_timers = [];

@onready var timers = get_node("%Timers");

func _ready():
	timers.timer_done.connect(_on_timer_done);
	
	randomize();
	name_pool = NamePool.new();
	adv_pool = AdventurerPool.new(name_pool);
	
	timers.create_timer(5);
	observed_timers.push_back(timers.create_timer(10));
	timers.create_timer(15);
	timers.create_timer(15);
	timers.create_timer(20);
	observed_timers.push_back(timers.create_timer(60));
	
	initialized = true;
	for id in observed_timers:
		var timer = timers._timers[id];
		print(str("<", timer._id, "> :: [", timer.get_timer_text(), "]"))
		pass;
	print(str("Observing timers: <", ", ".join(observed_timers) ,">"));
	pass;

func _process(delta):
	timers._process(delta);
	pass;

func _on_timer_done(id: String):
	if (observed_timers.has(id)):
		print(str(" -> The observed timer <", id, "> ended."));
