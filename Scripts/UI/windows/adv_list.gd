extends Panel

@onready var no_content = $NO_CONTENT;
@onready var adv_list = $LIST_VIEW;
@onready var content_parent = $LIST_VIEW.get_child(0).get_child(0);

var _game_manager : GameManager = null;
var _adv_manager : AdventurerManager = null;
var _start_index = 0;

func _ready():
	_game_manager = get_node("/root/Root/Game");
	_adv_manager = get_node("/root/Root/Adventurers");

func _process(delta):
	var adventurers = _adv_manager.recruited_adv();
	if adventurers.size() > 1:
		adventurers.sort_custom(func (a,b): return a.adv_name()[0] < b.adv_name()[0]);

	no_content.visible = adventurers.size() == 0;
	adv_list.visible = adventurers.size() > 0;
	
	_populate_list(adventurers);

func _populate_list(adventurers: Array):
	#print(adventurers.map(func (adv): return adv.adv_name()))
	for i in 6:
		var index = i + _start_index;
		var item = null;
		var party = null;
		if adventurers.size() > index:
			item = adventurers[index] as Adventurer;
			party = _adv_manager.get_adventurer_party(item._unique_id);
		content_parent.get_child(i).populate(item, party);

	pass;
