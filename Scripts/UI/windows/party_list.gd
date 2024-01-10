extends Panel

const IDLE_TOOLTIP = "Party is lounging around the guildhall.";
const ACTIVE_TOOLTIP = "Away on a mission.";
const EDIT_ACTIVE_TOOLTIP = "Cannot edit party when it's out on a mission."
const PAGE_SIZE = 6;
var _page: int = 0;

var idle_icon = ResourceLoader.load('res://Textures/Icons/snooze.png');
var active_icon = ResourceLoader.load('res://Textures/Icons/flag.png');


var test_parties = [
	Party.new("Alpha", [1, 2]), 
	Party.new("Beta", [1], Party.PartyStatus.ON_MISSION),
	Party.new("Gamma", [1]),
	Party.new("Delta", [1]),
	Party.new("Epsilon", [1]),
	Party.new("Zeta", [1]),
	Party.new("Eta", [1]),
	Party.new("Theta", [1], Party.PartyStatus.ON_MISSION),
	Party.new("Iota", [1], Party.PartyStatus.ON_MISSION),
	Party.new("Kappa", [1]),
	Party.new("Mu", [1]),
	Party.new("Delta", [1]),
	Party.new("Epsilon", [1]),
	Party.new("Zeta", [1], Party.PartyStatus.ON_MISSION),
	Party.new("Eta", [1]),
	Party.new("Theta", [1]),
	Party.new("Iota", [1]),
	Party.new("Kappa", [1])
];



func _ready():
	_draw_list();

func _draw_list():
	var content_parent = get_node("LIST/Panel/CONTENT_PARENT");
	get_node("LIST/PAGINATION/PAGE_NUM").text = str(_page + 1);
	for i in content_parent.get_children().size():
		var has_item = test_parties.size() > i + (_page * PAGE_SIZE);
		populate_item(content_parent.get_child(i), test_parties[i + (_page * PAGE_SIZE)] if has_item else null);


func change_page(delta: int):
	var page_max = floori(float(test_parties.size()) / float(PAGE_SIZE));
	_page = clampi(_page + delta, 0, page_max - 1);
	_draw_list();

func populate_item(list_item: Node, party: Party):
	list_item.visible = party != null;
	if list_item.visible != true: return;
	list_item.get_child(0).text = party._title;
	list_item.get_child(1).text = str(party._members.size(), "/", 3);
	list_item.get_child(-1).texture = idle_icon if party._status == Party.PartyStatus.IDLE else active_icon;
	list_item.get_child(-1).tooltip_text = IDLE_TOOLTIP if party._status == Party.PartyStatus.IDLE else ACTIVE_TOOLTIP;
	list_item.get_child(-2).disabled = party._status != Party.PartyStatus.IDLE;
	list_item.get_child(-2).tooltip_text = "" if party._status == Party.PartyStatus.IDLE else EDIT_ACTIVE_TOOLTIP;
	pass;


func _on_pagination_minus_pressed():
	change_page(-1);


func _on_pagination_plus_pressed():
	change_page(1);
