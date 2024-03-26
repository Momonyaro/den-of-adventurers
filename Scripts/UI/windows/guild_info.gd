extends Panel

var _window_base: Node = null;

var _game_manager : GameManager = null;
var _adv_manager : AdventurerManager = null;
var _req_manager : RequestManager = null;

func _ready():
	_game_manager = get_node("/root/Root/Game");
	_adv_manager = get_node("/root/Root/Adventurers");
	_req_manager = get_node("/root/Root/Requests");

func _process(delta):
	var guild_data = _game_manager.guild_data;
	var avg_level = str("%0.2f" % _adv_manager.avg_level());
	var recruited = _adv_manager.recruited().size();
	var adv_total = _adv_manager.recruited().size();
	
	get_node('Label').text = str(guild_data.guild_name);
	get_node('level_bar').populate(guild_data);
	get_node('info_box/adv_capacity').text = str('Adventurers: ', recruited, '/', guild_data.guildhall_adv_cap);
	get_node('info_box/adv_info/adv_total').text = str('Average Level: ', avg_level);
	get_node('info_box/adv_info/adv_avg_level').text = str('Total Adventurers: ', adv_total);
	get_node('info_box/req_info/req_active').text = str('Active Requests: ', _req_manager._active_requests.size()); 
	get_node('info_box/req_info/req_complete').text = str('Completed Requests: ', _req_manager._completed_requests.size());
	get_node('info_box/guild_tier').text = str('Current Guildhall Tier: ', guild_data.guildhall_tier + 1);
	
	get_node("info_box/Panel/MarginContainer/GridContainer/Button").disabled = true;
