extends Panel

var _game_manager : GameManager = null;
var _adv_manager : AdventurerManager = null;

var _selected_agent : Agent = null;
var _window_base: Node = null;
var _on_close_action: Callable = func (): get_tree().root.get_child(1).get_child(0).select_agent.emit(null);

@onready var human_icon = ResourceLoader.load("res://Textures/Icons/human.png");
@onready var demihuman_icon = ResourceLoader.load("res://Textures/Icons/demi-human.png");

func _ready():
	_game_manager = get_node("/root/Root/Game");
	_adv_manager = get_node("/root/Root/Adventurers");
	_selected_agent = _game_manager._selected_agent;
	_game_manager.select_agent.connect(update_menu);
	get_node("%AdvHealthRect/fatigue/bar/rest_btn").pressed.connect( func(): 
		_window_base.play_audio("res://Audio/SFX/UI/click_004.ogg"); 
		_selected_agent.adventurer.set_status(Adventurer.Status.RESTING)
	);
	pass;

func _process(_delta):
	update_menu(null); # Null because the event it's attached to sends an agent but we don't use it.

func update_menu(_agent):
	if _selected_agent == null || _selected_agent.adventurer == null:
		return;
	
	_draw_basic_info();
	_draw_health_info();

	var list_size = get_child(0).get_global_rect().size;
	var base_size = self.get_global_rect().size
	if list_size != base_size:
		self.set_size(list_size);
		_window_base.resize_app();

func _draw_basic_info():
	var adventurer = _selected_agent.adventurer;
	var current_status = adventurer.adv_status();
	var is_human = adventurer._race == Adventurer.Race.HUMAN;
	var xp_ratio = adventurer.xp_percentage();
	
	get_node("%BaseInfoRect/name").text = str(adventurer.adv_name());
	get_node("%BaseInfoRect/race").texture = human_icon if is_human else demihuman_icon;
	get_node("%BaseInfoRect/race").tooltip_text = "Human" if is_human else "Demi-Human";
	get_node("%BaseInfoRect/level_race").text = str("Level ", adventurer._level, " ", adventurer._class);
	get_node("%BaseInfoRect/state").visible = current_status != "RECRUIT";
	get_node("%BaseInfoRect/state").text = current_status;
	get_node("%BaseInfoRect/xp_bar").visible = current_status != "RECRUIT";
	get_node("%BaseInfoRect/xp_bar").value = xp_ratio;
	get_node("%BaseInfoRect/recruit_btn").visible = current_status == 'RECRUIT';
	get_node("%BaseInfoRect/recruit_btn").disabled = !_check_capacity();
	get_node("%BaseInfoRect/star").visible = adventurer._defined;
	get_node("%BaseInfoRect/recruit_btn").tooltip_text = "Your guild can't house any more recruits!" if !_check_capacity() else "Recruit a new adventurer to your guild";

func _draw_health_info():
	var adventurer = _selected_agent.adventurer;
	var current_status = adventurer.adv_status();
	var resting = current_status == "RESTING" || current_status == "EXHAUSTED"

	get_node("%AdvHealthRect").visible = current_status != "RECRUIT";
	get_node("%AdvHealthRect/health").text = str("Health: (", adventurer._health.x, "/", adventurer._health.y, ")");
	get_node("%AdvHealthRect/health/bar").value = adventurer._health.x / float(adventurer._health.y);
	get_node("%AdvHealthRect/fatigue").text = _get_fatigue_text(adventurer._fatigue);
	get_node("%AdvHealthRect/fatigue/bar").value = adventurer._fatigue / 1.0;
	var is_enabled = adventurer._fatigue >= 0.1 && adventurer.adv_status() == "IDLE";
	get_node("%AdvHealthRect/fatigue/bar/rest_btn").disabled = !is_enabled;
	get_node("%AdvHealthRect/fatigue/bar/rest_btn").tooltip_text = "Tell the adventurer to go rest." if is_enabled else "";
	if resting:
		get_node("%AdvHealthRect/fatigue/bar/rest_btn").text = get_timer_text(adventurer._fatigue, adventurer.FATIGUE_REST_TIME);
	else:
		get_node("%AdvHealthRect/fatigue/bar/rest_btn").text = "Rest";


func _check_capacity():
	var max = _game_manager._max_adventurers;
	var current = _adv_manager.recruited().size();
	return current < max;

func _get_fatigue_text(_fatigue: float):
	return str("Fatigue: (", "%0.0f" % (_fatigue / 1.0 * 100), "%)");

func get_timer_text(_fatigue: float, _fatigue_total_time: float) -> String:
	var return_val = "";
	var inv_value : float = (_fatigue_total_time * _fatigue);
	var hours : float = inv_value / 3600;
	var hours_floored = floori(hours);
	if hours_floored > 0:
		return_val += str("%02d" % hours_floored, "h")
	var minutes : float = (hours - hours_floored) * 60;
	var minutes_floored = floori(minutes);
	if minutes_floored > 0:
		return_val += str(" ", "%02d" % minutes_floored, "m")
	var seconds : float = (minutes - minutes_floored) * 60;
	var seconds_rounded = ceili(seconds);
	if seconds_rounded == 60 && minutes_floored > 0:
		seconds_rounded = 0;
	return_val += str(" ", seconds_rounded, "s")
	
	return return_val;

func _on_recruit_btn_pressed():
	_window_base.play_audio("res://Audio/SFX/UI/click_004.ogg");
	_selected_agent._recruit();
