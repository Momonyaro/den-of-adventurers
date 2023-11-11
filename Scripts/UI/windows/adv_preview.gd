extends Panel

var _game_manager : GameManager = null;
var _adv_manager : AdventurerManager = null;

var _selected_agent : Agent = null;
var _window_base: Node = null;
var _on_close_action: Callable = func (): get_tree().root.get_child(1).get_child(0).select_agent.emit(null);

func _ready():
	_game_manager = get_node("/root/Root/Game");
	_adv_manager = get_node("/root/Root/Adventurers");
	_selected_agent = _game_manager._selected_agent;
	_game_manager.select_agent.connect(update_menu);
	pass;

func _process(_delta):
	update_menu(null);

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
	var xp_ratio = adventurer.xp_percentage();
	
	get_node("%BaseInfoRect/name").text = adventurer.adv_name();
	get_node("%BaseInfoRect/level_race").text = str("Level ", adventurer._level, " ", adventurer.adv_race());
	get_node("%BaseInfoRect/state").text = current_status;
	get_node("%BaseInfoRect/xp_bar").visible = current_status != "RECRUIT";
	get_node("%BaseInfoRect/xp_bar").value = xp_ratio;
	get_node("%BaseInfoRect/recruit_btn").visible = current_status == 'RECRUIT';
	get_node("%BaseInfoRect/recruit_btn").disabled = !_check_capacity();
	#get_node("%BaseInfoRect/recruit_btn").tooltip_text = "You guild can't house any more recruits!" if !_check_capacity() else "Recruit a new adventurer to your guild";

func _draw_health_info():
	var adventurer = _selected_agent.adventurer;
	var current_status = adventurer.adv_status();

	get_node("%AdvHealthRect").visible = current_status != "RECRUIT";
	get_node("%AdvHealthRect/health").text = str("Health: (", adventurer._health.x, "/", adventurer._health.y, ")");
	get_node("%AdvHealthRect/health/bar").value = adventurer._health.x / float(adventurer._health.y);
	get_node("%AdvHealthRect/fatigue").text = str("Fatigue: (", "%0.0f" % (adventurer._fatigue / 1.0 * 100), "%)");
	get_node("%AdvHealthRect/fatigue/bar").value = adventurer._fatigue / 1.0;
	get_node("%AdvHealthRect/fatigue/bar/rest_btn").disabled = adventurer._fatigue < 0.1 || adventurer.adv_status() != "IDLE";


func _check_capacity():
	var max = _game_manager._max_adventurers;
	var current = _adv_manager.recruited().size();
	return current < max;

func _on_recruit_btn_pressed():
	_selected_agent._recruit();
