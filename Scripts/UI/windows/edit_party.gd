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
	var confirm_btn = get_node("CONFIRM_BTN") as Button;

	var party = _adv_manager.party_edited;
	var members = party._members;
	title_label.text = str("Title");
	title_cap.text = str("(", party._title.length(), "/", title_edit.max_length, ")");
	title_edit.text = party._title;
	confirm_btn.disabled = party._members.size() == 0;

	member_cap.text = str('(', party._members.size(), '/3)');
	var content_parent = get_node("MEMBER_LIST/CONTENT_PARENT");
	var recruited = _adv_manager.recruited_adv();
	recruited.sort_custom(func (a,b): return a.adv_name()[0] < b.adv_name()[0]);
	get_node("PAGINATION/PAGE_NUM").text = str(_page + 1);
	for i in content_parent.get_children().size():
		var has_item = recruited.size() > i + (_page * PAGE_SIZE);
		var in_party = members.has(recruited[i]._unique_id) if has_item else false;
		populate_item(content_parent.get_child(i), recruited[i] if has_item else null, in_party);
	

func populate_item(list_item: Node, adventurer: Adventurer, in_party: bool):
	list_item.visible = adventurer != null;
	if list_item.visible != true: return;
	(list_item.get_child(0) as CheckBox).button_pressed = in_party;
	(list_item.get_child(1) as Label).text = adventurer.adv_name();
	(list_item.get_child(2) as Label).text = str("Level ", adventurer.adv_level(), " ", adventurer._class);

	var _edit_func = func (): _on_edit_members(_adv_manager.party_edited, adventurer._unique_id); populate_fields();
	var check_box = list_item.get_child(0) as CheckBox;

	for result in check_box.get_signal_connection_list('pressed'):
		check_box.disconnect((result['signal'] as Signal).get_name(), result['callable']);
	check_box.pressed.connect(_edit_func);

	var has_party = _adv_manager.get_adventurer_party(adventurer._unique_id) != null;
	(list_item.get_child(3) as Label).visible = has_party;

func _on_close_btn_pressed():
	_adv_manager.upsert_party(_adv_manager.party_edited);
	_adv_manager.party_edited = null;
	_window_base._on_win_close();
	pass # Replace with function body.

func _on_title_text_changed(new_text:String):
	print(new_text);
	var title_edit = get_node("LineEdit") as LineEdit;
	var title_cap = get_node("LineEdit/CAP") as Label;
	
	_adv_manager.party_edited._title = new_text;
	#title_edit.text = new_text;
	title_cap.text = str("(", new_text.length(), "/", title_edit.max_length, ")");

	pass # Replace with function body.

func _on_edit_members(party: Party, changed: String):
	if party._members.has(changed):
		party._members = party._members.filter(func (m): return m != changed);
	else:
		if (party._members.size() + 1) > 3:
			party._members.resize(3);
			return;

		var existing_party = _adv_manager.get_adventurer_party(changed);
		# Here we should check if the adventurer is in another party.

		if existing_party && party._created_timestamp != existing_party._created_timestamp:
			var adv = _adv_manager._adventurers[changed];
			if existing_party._members.size() == 1:
				_window_base.create_prompt(
					'Move Adventurer', 
					str('Are you sure you want to move ', adv.adv_name(), '? This action will delete party "', party._title, '" since it has no remaining members!'),
					'res://Textures/Icons/options.png',
					str('Move ', adv.adv_name(), ' anyway'),
					'Cancel',
					func(): 
						_adv_manager.remove_party_member(changed);
						_adv_manager.remove_empty_parties();
						party._members.push_back(changed);
						populate_fields();
				);
			else:
				_window_base.create_prompt(
					'Move Adventurer', 
					str('Are you sure you want to move ', adv.adv_name(), '?'),
					'res://Textures/Icons/options.png',
					str('Move ', adv.adv_name()),
					'Cancel',
					func(): 
						_adv_manager.remove_party_member(changed);
						_adv_manager.remove_empty_parties();
						party._members.push_back(changed);
						populate_fields();
				);
			pass;
		else:
			party._members.push_back(changed);

