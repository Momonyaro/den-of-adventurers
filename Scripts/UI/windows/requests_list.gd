extends Panel

@onready var world_map = $HBoxContainer/WORLD_MAP;
@onready var req_manager : RequestManager = get_node("/root/Root/Requests");
@onready var reward_box = preload("res://Prefabs/UI/components/reward_box.tscn");
@onready var requirement_item = preload("res://Prefabs/UI/requirement_item.tscn");
@onready var adv_manager : AdventurerManager = get_node("/root/Root/Adventurers");

@onready var request_container = get_node("HBoxContainer/REQUEST_HOLDER/REQUEST_LIST");
@onready var detail_container = get_node("HBoxContainer/REQUEST_HOLDER/REQUEST_DETAILS");
@onready var time_remaining = get_node("HBoxContainer/REQUEST_HOLDER/REQUEST_DETAILS/REQUIREMENTS/VBoxContainer/TIME_REMAINING/MarginContainer/VBoxContainer/HBoxContainer/VALUE");

var current_request = "";

func _ready():
	_open_list();

func _process(delta):
	if current_request != "":
		var result = req_manager._try_get_request(current_request);
		if !result[0]:
			return;

		var request = result[1] as RequestManager.RequestItem;
		
		if request._is_active:
			var active_request = req_manager._active_requests[request._id] as RequestManager.ActiveRequestItem;
			if active_request == null:
				return;
			var timers = req_manager.timers;

			var go_to_time = 0 if active_request.TIMER_go_to == "" else timers._timers[active_request.TIMER_go_to].get_timer_seconds();
			var duration_time = 0 if active_request.TIMER_duration == "" else timers._timers[active_request.TIMER_duration].get_timer_seconds();
			var go_home_time = 0 if active_request.TIMER_go_home == "" else timers._timers[active_request.TIMER_go_home].get_timer_seconds();
			var remainingTime = TimerContainer.InternalTimer.new("lala", go_to_time + duration_time + go_home_time, "throw-away", false);

			time_remaining.text = remainingTime.get_timer_fancy_text();

func _open_request():
	request_container.visible = false;
	detail_container.visible = true;
	
	var title = get_node("HBoxContainer/REQUEST_HOLDER/REQUEST_DETAILS/TITLE") as Label;
	var requestor = get_node("HBoxContainer/REQUEST_HOLDER/REQUEST_DETAILS/REQUESTOR/Label") as Label;
	var body = get_node("HBoxContainer/REQUEST_HOLDER/REQUEST_DETAILS/BODY/TITLE2") as Label;
	var time_estimate = get_node("HBoxContainer/REQUEST_HOLDER/REQUEST_DETAILS/REQUIREMENTS/VBoxContainer/BTM_CONTAINER/TITLE3") as Label;
	var rewards_container = get_node("HBoxContainer/REQUEST_HOLDER/REQUEST_DETAILS/REQUIREMENTS/VBoxContainer/REWARDS/FLOW_CONTAINER");
	var bottom_section = get_node("HBoxContainer/REQUEST_HOLDER/REQUEST_DETAILS/REQUIREMENTS/VBoxContainer/BTM_CONTAINER");
	var remaining_section = get_node("HBoxContainer/REQUEST_HOLDER/REQUEST_DETAILS/REQUIREMENTS/VBoxContainer/TIME_REMAINING");
	var active_party = get_node("HBoxContainer/REQUEST_HOLDER/REQUEST_DETAILS/REQUIREMENTS/VBoxContainer/TIME_REMAINING/MarginContainer/VBoxContainer/HBoxContainer2/VALUE");
	var dropdown = get_node("HBoxContainer/REQUEST_HOLDER/REQUEST_DETAILS/REQUIREMENTS/VBoxContainer/BTM_CONTAINER/dropdown") as Dropdown;
	var requirement_container = get_node("HBoxContainer/REQUEST_HOLDER/REQUEST_DETAILS/REQUIREMENTS/VBoxContainer/BTM_CONTAINER/REQUIREMENTS");
	var accept_btn = get_node("HBoxContainer/REQUEST_HOLDER/REQUEST_DETAILS/REQUIREMENTS/VBoxContainer/BTM_CONTAINER/edit_btn") as Button;
	var complete_btn = get_node("HBoxContainer/REQUEST_HOLDER/REQUEST_DETAILS/REQUIREMENTS/VBoxContainer/complete_btn") as Button;

	var result = req_manager._try_get_request(current_request);
	if !result[0]:
		return;
	
	var request = result[1] as RequestManager.RequestItem;
	var rewards = _get_rewards_dict(request._rewards);

	var distance = world_map.calculate_path(request._location);
	var fake_timer = TimerContainer.InternalTimer.new("fafa", distance + request._duration + (distance * 0.5), "throw-away", false);
	time_estimate.text = str("Estimated Duration: " + fake_timer.get_timer_fancy_text());

	var existing_children = rewards_container.get_children();
	for child in existing_children:
		child.queue_free();

	# Rewards
	for key in rewards.keys():
		var _reward_box = reward_box.instantiate();
		rewards_container.add_child(_reward_box);
		_reward_box.populate(_get_reward_icon(key), _parse_reward_name(key), str(rewards[key]));

	bottom_section.visible = (!request._is_active && !request._is_completed);
	remaining_section.visible = request._is_active;

	title.text = request._title;
	requestor.text = request._requestor;
	body.text = request._body;

	# Party Dropdown
	var parties = adv_manager.get_available_parties();
	dropdown.clear_items();
	parties.sort_custom(func (a, b): return a._title < b._title);
	dropdown._disabled = parties.size() == 0;

	if parties.size() == 0:
		dropdown.set_active_no_event("No Parties Found", -1);
	for i in parties.size():
		var party = parties[i];
		dropdown.add_item(str(party._title, " - ", party._members.size(), " member(s)"), party._created_timestamp, i);

	var existing_children2 = requirement_container.get_children();
	for child in existing_children2:
		child.queue_free();

	# Remaining Time
	if request._is_active && !request._is_completed:
		var active_request = req_manager._active_requests[request._id] as RequestManager.ActiveRequestItem;
		var timers = req_manager.timers;

		var go_to_time = 0 if active_request.TIMER_go_to == "" else timers._timers[active_request.TIMER_go_to].get_timer_seconds();
		var duration_time = 0 if active_request.TIMER_duration == "" else timers._timers[active_request.TIMER_duration].get_timer_seconds();
		var go_home_time = 0 if active_request.TIMER_go_home == "" else timers._timers[active_request.TIMER_go_home].get_timer_seconds();
		var remainingTime = TimerContainer.InternalTimer.new("lala", go_to_time + duration_time + go_home_time, "throw-away", false);

		time_remaining.text = remainingTime.get_timer_fancy_text();
	
	time_remaining.get_parent().visible = !request._is_completed;


	# Requirements
	var passed_requirements = true;
	for requirement in request._requirements:
		var item = requirement.split('$');
		var req_match = req_manager.get_requirement(item[0], int(item[1]) if item.size() > 1 else 0) as Requirement;
		var req_validation = req_match.validate(adv_manager.get_party(dropdown._get_current_item()._value)) if dropdown._get_current_item() != null else false;
		var instance = requirement_item.instantiate();
		requirement_container.add_child(instance);
		instance.get_child(0).visible = req_validation;
		instance.get_child(1).visible = !req_validation;
		instance.get_child(-1).text = req_match.get_requirement();
		if !req_validation:
			passed_requirements = false;
	
	if request._requirements.size() == 0:
		var instance2 = requirement_item.instantiate();
		requirement_container.add_child(instance2);
		instance2.get_child(0).visible = true;
		instance2.get_child(1).visible = false;
		instance2.get_child(-1).text = "No Requirements";
	
	active_party.get_parent().visible = request._is_active;
	var matches = adv_manager.try_get_party_with_request(request._id);
	var request_completed = false;
	if matches.size() > 0:
		request_completed = matches[0]._status == Party.PartyStatus.RETURNED;
		active_party.text = matches[0]._title;


	# Submit button
	var submit_func = func():
		req_manager.accept_request(request, adv_manager.get_party(dropdown._get_current_item()._value), distance, request._duration, (distance * 0.5));
		#req_manager.accept_request(request, adv_manager.get_party(dropdown._get_current_item()._value), 5, 5, 5);
		_open_request();
	
	# Complete button
	var complete_func = func():
		req_manager.complete_request(request, matches[0] if request_completed else null);
		_open_list();

	accept_btn.disabled = !passed_requirements || parties.size() == 0 || dropdown._get_current_item() == null;
	for sig in accept_btn.get_signal_connection_list('pressed'):
		accept_btn.disconnect((sig['signal'] as Signal).get_name(), sig['callable']);
	accept_btn.pressed.connect(submit_func);

	complete_btn.visible = request_completed;
	complete_btn.disabled = !request_completed && matches.size() == 0;
	for sig in complete_btn.get_signal_connection_list('pressed'):
		complete_btn.disconnect((sig['signal'] as Signal).get_name(), sig['callable']);
	complete_btn.pressed.connect(complete_func);




func _open_list():
	request_container.visible = true;
	detail_container.visible = false;
	world_map.clear_path();
	var requests = req_manager.get_requests();
	
	var req_container = request_container.get_child(1);
	var req_list = requests['Active'];
	req_list.append_array(requests['Available']);
	req_list.append_array(requests['Completed']);

	for i in req_container.get_child_count():
		var item = req_list[i] if req_list.size() > i else null;
		var child = req_container.get_child(i);
		var is_active = item._is_active if item != null else false;
		var matches = adv_manager.try_get_party_with_request(item._id) if item != null else [];
		var party = matches[0] if matches.size() > 0 else null;
		var is_returned = party._status == Party.PartyStatus.RETURNED if party != null else false;

		child.populate_item(item, is_active, is_returned, item._is_completed if item != null else false, _on_click_open_btn);

func _on_click_open_btn(id: String):

	current_request = id;
	_open_request();

func _on_close_btn_pressed():
	current_request = "";
	_open_list();
	pass # Replace with function body.

func _get_rewards_dict(rewards: Array):
	var dict: Dictionary = {};
	for reward in rewards:
		var split = reward.split('$');
		var item_title = split[0];
		var item_amount = int(split[1]) if split.size() > 1 else 1;
		dict[item_title] = item_amount;
	
	return dict;

func _get_reward_icon(reward_key: String) -> Texture2D:
	match(reward_key.to_lower()):
		"gold": return ResourceLoader.load("res://Textures/Icons/gold.png") as Texture2D;
		_: return Texture2D.new();

func _parse_reward_name(reward_key: String) -> String:
	match(reward_key.to_lower()):
		"gold": return "Gold";
		"g_xp": return "Guild Experience";
		_: return "Item";

func _on_dropdown_new_current(_label, _value, _id):

	_open_request();
	pass # Replace with function body.

