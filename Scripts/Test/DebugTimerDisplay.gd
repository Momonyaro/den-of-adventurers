extends Control

@onready var timers : TimerContainer = get_node("/root/Root/Timers");
@onready var icon = preload("res://Textures/Icons/timer.png");
var update = false;

func _ready():
	Console.add_command("display_timers", _display_timers, 1);
	self.visible = false;

func _process(_delta):
	if !update: return;

	var active_timers = timers._get_timers();
	active_timers.sort_custom(sort_ascending);
	var item_list = $ItemList;

	item_list.clear();
	for active_timer in active_timers:
		var idx = item_list.add_item(str("<", active_timer._id, "> [", active_timer.get_timer_text(), "]"), icon, false);
		item_list.set_item_tooltip(idx, active_timer._description);

	pass;

func _display_timers(arg0: String):
	match (arg0):
		'0': self.visible = false; update = false;
		'1': self.visible = true; update = true;
		_: Console.print_line("Invalid Value.");

func sort_ascending(a, b):
	if a.get_timer_seconds() < b.get_timer_seconds():
		return true
	return false
