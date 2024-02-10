extends Panel

const IDLE_TOOLTIP = "Party is lounging around the guildhall.";
const ACTIVE_TOOLTIP = "Away on a mission.";
const EDIT_IDLE_TOOLTIP = "Edit party.";
const EDIT_ACTIVE_TOOLTIP = "Cannot edit party when it's out on a mission.";
const PAGE_SIZE = 6;
var _page: int = 0;
var _window_base: Node = null;
var _adv_manager : AdventurerManager = null;
var _edited_was_null = false;
var _on_close_action: Callable = func (): _window_base._manager.process_command("WINDOW:FORCE_CLOSE:EDIT_PARTY");

var idle_icon = ResourceLoader.load('res://Textures/Icons/snooze.png');
var active_icon = ResourceLoader.load('res://Textures/Icons/flag.png');


func _ready():
	_adv_manager = get_node("/root/Root/Adventurers");
	_draw_list(true);

func _process(_delta):
	var _edited_is_null = _adv_manager.party_edited == null;

	if _edited_is_null != _edited_was_null:
		_edited_was_null = _edited_is_null;
		_draw_list(true);

func _draw_list(full_update: bool = false):
	var content_parent = get_node("LIST/Panel/CONTENT_PARENT");
	get_node("LIST/PAGINATION/PAGE_NUM").text = str(_page + 1);
	get_node("LIST/CREATE_PARTY").tooltip_text = "Form a new party from scratch.";
	for i in content_parent.get_children().size():
		var has_item = _adv_manager._parties.size() > i + (_page * PAGE_SIZE);
		populate_item(content_parent.get_child(i), _adv_manager._parties[i + (_page * PAGE_SIZE)] if has_item else null, i, full_update);


func change_page(delta: int):
	var zero_offset = 1 if _adv_manager._parties.size() % PAGE_SIZE == 0 else 0;
	var page_max = floori(float(_adv_manager._parties.size()) / float(PAGE_SIZE));
	_page = clampi(_page + delta, 0, page_max - zero_offset);
	_page = maxi(0, _page);
	_draw_list(true);

func populate_item(list_item: Node, party: Party, index: int, full_update: bool = false):
	list_item.visible = party != null;
	if list_item.visible != true: return;
	list_item.get_child(0).text = party._title;
	list_item.get_child(1).text = str(party._members.size(), "/", 3);
	list_item.get_child(-1).texture = idle_icon if party._status == Party.PartyStatus.IDLE else active_icon;
	list_item.get_child(-1).tooltip_text = IDLE_TOOLTIP if party._status == Party.PartyStatus.IDLE else ACTIVE_TOOLTIP;
	list_item.get_child(-2).disabled = party._status != Party.PartyStatus.IDLE;
	list_item.get_child(-2).tooltip_text = EDIT_IDLE_TOOLTIP if party._status == Party.PartyStatus.IDLE else EDIT_ACTIVE_TOOLTIP;
	var _edit_func = func(): _adv_manager.party_edited = Party.copy(_adv_manager.get_party_by_index(index)); _window_base._manager.process_command("WINDOW:RESET:EDIT_PARTY", get_global_mouse_position());
	var _del_func = func(): _on_delete_btn(party._title, index);
	var edit_btn = list_item.get_child(-2) as Button;
	var del_btn = list_item.get_child(-3) as Button;

	if full_update:
		if edit_btn.pressed.is_connected(_edit_func):
			edit_btn.pressed.disconnect(_edit_func);
		edit_btn.pressed.connect(_edit_func);
		if del_btn.pressed.is_connected(_del_func):
			del_btn.pressed.disconnect(_del_func);
		del_btn.pressed.connect(_del_func);
	pass;


func _on_pagination_minus_pressed():
	change_page(-1);


func _on_pagination_plus_pressed():
	change_page(1);

func _on_create_party_pressed():
	_adv_manager.create_party();
	_window_base._manager.process_command("WINDOW:RESET:EDIT_PARTY", get_global_mouse_position());
	# Open window for editing party.
	pass # Replace with function body.

func _on_delete_btn(party_title, index):
	_window_base.create_prompt(
		'Delete Party', 
		str('Are you sure you want to delete party "', party_title, '"?'),
		'res://Textures/Icons/options.png',
		'Yes, Delete Party',
		'No',
		func(): 
			_adv_manager._parties.remove_at(index); 
			change_page(0);
	);


