extends Panel

var open_callback: Callable;

func populate_item(request: RequestManager.RequestItem, is_active: bool, is_completed: bool, on_click_open: Callable):
	self.visible = request != null;
	if !self.visible:
		return;

	var active_strip = get_node("HBoxContainer/ACTIVE_STRIP") as TextureRect;
	var request_title = get_node("HBoxContainer/Control/Label") as Label;
	var gold_label = get_node("HBoxContainer/Control/SUB_VALUES/GOLD/Label") as Label;
	var requestor_label = get_node("HBoxContainer/Control/SUB_VALUES/REQUESTOR/Label") as Label;
	var location_label = get_node("HBoxContainer/Control/SUB_VALUES/LOCATION/Label") as Label;

	var reward_dict = _get_rewards_dict(request._rewards);

	active_strip.visible = is_active;
	request_title.text = request._title;
	gold_label.text = str(reward_dict['gold'] if reward_dict.has('gold') else 0);
	requestor_label.text = request._requestor;
	location_label.text = request._location;
	
	open_callback = func (): on_click_open.call(request._id);

	pass;

func _get_rewards_dict(rewards: Array):
	var dict: Dictionary = {};
	for reward in rewards:
		var split = reward.split('$');
		var item_title = split[0];
		var item_amount = int(split[1]) if split.size() > 1 else 1;
		dict[item_title] = item_amount;
	
	return dict;
		

func _on_open_btn_pressed():
	open_callback.call();
	pass # Replace with function body.
