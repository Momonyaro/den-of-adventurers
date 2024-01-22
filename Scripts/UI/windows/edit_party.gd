extends Panel

const PAGE_SIZE = 7;

var _page: int = 0;
var _window_base: Node = null;
var _initialized: bool = false;
var _adv_manager : AdventurerManager = null;

func _ready():
	_adv_manager = get_node("/root/Root/Adventurers");

func _process(_delta):
	if !_initialized:
		if _window_base != null:
			populate_fields();
			_initialized = true;
	pass;

func populate_fields():
	var title_edit = get_node("LineEdit") as LineEdit;
	var title_label = get_node("LineEdit/Label") as Label;
	var title_cap = get_node("LineEdit/CAP") as Label;
	var member_cap = get_node("MEMBER_LIST/CAP") as Label;

	var party = _adv_manager.party_edited;
	var members = party._members;
	title_label.text = str("Title");
	title_cap.text = str("(", party._title.length(), "/", title_edit.max_length, ")");
	title_edit.text = party._title;

	member_cap.text = str('(', party._members.size(), '/3)');
	var content_parent = get_node("MEMBER_LIST/CONTENT_PARENT");
	var recruited = _adv_manager.recruited_adv();
	get_node("PAGINATION/PAGE_NUM").text = str(_page + 1);
	for i in content_parent.get_children().size():
		var has_item = recruited.size() > i + (_page * PAGE_SIZE);
		var in_party = members.has(recruited[i]._unique_id) if has_item else false;
		populate_item(content_parent.get_child(i), recruited[i] if has_item else null, in_party);
	

func populate_item(list_item: Node, adventurer: Adventurer, in_party: bool):
	list_item.visible = adventurer != null;
	if list_item.visible != true: return;
	(list_item.get_child(0) as CheckBox).button_pressed = in_party;
	(list_item.get_child(0) as CheckBox).pressed.connect(func (): 
		_on_edit_members(_adv_manager.party_edited, adventurer._unique_id); 
		populate_fields();, CONNECT_ONE_SHOT
	);
	(list_item.get_child(1) as Label).text = adventurer.adv_name();
	(list_item.get_child(2) as Label).text = str("Level ", adventurer._level, " ", adventurer._class);
	pass;

func _on_close_btn_pressed():
	_adv_manager.upsert_party(_adv_manager.party_edited);
	_window_base._on_win_close();
	pass # Replace with function body.

func _on_title_text_changed(new_text:String):
	print(new_text);
	var title_edit = get_node("LineEdit") as LineEdit;
	var title_cap = get_node("LineEdit/CAP") as Label;
	
	_adv_manager.party_edited._title = new_text;
	title_cap.text = str("(", new_text.length(), "/", title_edit.max_length, ")");

	pass # Replace with function body.

func _on_edit_members(party: Party, changed: String):
	if party._members.has(changed):
		party._members = party._members.filter(func (m): return m != changed);
	else:
		party._members.push_back(changed);
		if party._members.size() > 3:
			party._members.resize(3);
