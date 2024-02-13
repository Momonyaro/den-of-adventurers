extends Panel

@onready var req_manager : RequestManager = get_node("/root/Root/Requests");
@onready var reward_box = preload("res://Prefabs/UI/components/reward_box.tscn");
@onready var requirement_item = preload("res://Prefabs/UI/requirement_item.tscn");
@onready var adv_manager : AdventurerManager = get_node("/root/Root/Adventurers");

var current_request = "";

func _ready():
	var request_container = get_node("HBoxContainer/REQUEST_HOLDER/REQUEST_LIST/LIST_CONTAINER");
	var detail_container = get_node("HBoxContainer/REQUEST_HOLDER/REQUEST_DETAILS");
	_open_list(detail_container, request_container);

func _open_request(detail_container, request_container):
	request_container.visible = false;
	detail_container.visible = true;
	
	var title = get_node("HBoxContainer/REQUEST_HOLDER/REQUEST_DETAILS/TITLE") as Label;
	var requestor = get_node("HBoxContainer/REQUEST_HOLDER/REQUEST_DETAILS/REQUESTOR/Label") as Label;
	var body = get_node("HBoxContainer/REQUEST_HOLDER/REQUEST_DETAILS/BODY/TITLE2") as Label;

	var result = req_manager._try_get_request(current_request);
	if !result[0]:
		return;
	
	var request = result[1] as RequestManager.RequestItem;

	var rewards = _get_rewards_dict(request._rewards);
	var rewards_container = get_node("HBoxContainer/REQUEST_HOLDER/REQUEST_DETAILS/REQUIREMENTS/VBoxContainer/REWARDS/FLOW_CONTAINER");
	var existing_children = rewards_container.get_children();
	for child in existing_children:
		child.queue_free();

	for key in rewards.keys():
		var _reward_box = reward_box.instantiate();
		rewards_container.add_child(_reward_box);
		var title_key = key[0].to_upper() + key.substr(1,-1);
		_reward_box.populate(_get_reward_icon(key), title_key, str(rewards[key]));

	var bottom_section = get_node("HBoxContainer/REQUEST_HOLDER/REQUEST_DETAILS/REQUIREMENTS/VBoxContainer/BTM_CONTAINER");
	bottom_section.visible = (!request._is_active && !request._is_completed);
	var remaining_section = get_node("HBoxContainer/REQUEST_HOLDER/REQUEST_DETAILS/REQUIREMENTS/VBoxContainer/TIME_REMAINING");
	remaining_section.visible = request._is_active;

	title.text = request._title;
	requestor.text = request._requestor;
	body.text = request._body;

	var dropdown = get_node("HBoxContainer/REQUEST_HOLDER/REQUEST_DETAILS/REQUIREMENTS/VBoxContainer/BTM_CONTAINER/dropdown") as Dropdown;
	var parties = adv_manager._parties;
	dropdown.clear_items();
	parties.sort_custom(func (a, b): return a._title < b._title);
	dropdown._disabled = parties.size() == 0;

	if parties.size() == 0:
		dropdown.set_active_no_event("No Parties Found", -1);
	for i in parties.size():
		var party = parties[i];
		dropdown.add_item(str(party._title, " - ", party._members.size(), " member(s)"), party._created_timestamp, i);

	var requirement_container = get_node("HBoxContainer/REQUEST_HOLDER/REQUEST_DETAILS/REQUIREMENTS/VBoxContainer/BTM_CONTAINER/REQUIREMENTS");
	requirement_container.visible = request._requirements.size() > 0;
	var existing_children2 = requirement_container.get_children();
	for child in existing_children2:
		child.queue_free();

	for requirement in request._requirements:
		var item = requirement.split('$');
		var req_match = req_manager.get_requirement(item[0], int(item[1]) if item.size() > 1 else 0) as Requirement;
		var req_validation = req_match.validate(adv_manager.get_party(dropdown._get_current_item()._value)) if dropdown._get_current_item() != null else false;
		var instance = requirement_item.instantiate();
		requirement_container.add_child(instance);
		instance.get_child(0).visible = req_validation;
		instance.get_child(1).visible = !req_validation;
		instance.get_child(-1).text = req_match.get_requirement();

func _open_list(detail_container, request_container):
	request_container.get_parent().visible = true;
	detail_container.visible = false;
	var requests = req_manager.get_requests();
	
	var req_list = requests['Active'];
	req_list.append_array(requests['Available']);
	req_list.append_array(requests['Completed'])

	for i in request_container.get_child_count():
		var item = req_list[i] if req_list.size() > i else null;
		var child = request_container.get_child(i);

		child.populate_item(item, item._is_active if item != null else false, item._is_completed if item != null else false, _on_click_open_btn);

func _on_click_open_btn(id: String):
	var request_container = get_node("HBoxContainer/REQUEST_HOLDER/REQUEST_LIST");
	var detail_container = get_node("HBoxContainer/REQUEST_HOLDER/REQUEST_DETAILS");

	current_request = id;
	_open_request(detail_container, request_container);

func _on_close_btn_pressed():
	var request_container = get_node("HBoxContainer/REQUEST_HOLDER/REQUEST_LIST/LIST_CONTAINER");
	var detail_container = get_node("HBoxContainer/REQUEST_HOLDER/REQUEST_DETAILS");
	
	current_request = "";
	_open_list(detail_container, request_container);
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


func _on_dropdown_new_current(_label, _value, _id):
	var request_container = get_node("HBoxContainer/REQUEST_HOLDER/REQUEST_LIST");
	var detail_container = get_node("HBoxContainer/REQUEST_HOLDER/REQUEST_DETAILS");

	_open_request(detail_container, request_container);
	pass # Replace with function body.
