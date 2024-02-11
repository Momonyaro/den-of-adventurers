extends Panel

@onready var req_manager : RequestManager = get_node("/root/Root/Requests");

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
	title.text = request._title;
	requestor.text = request._requestor;
	body.text = request._body;

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
