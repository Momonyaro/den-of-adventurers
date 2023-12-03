extends Panel

@onready var no_content = $NO_CONTENT;
@onready var adv_list = $LIST_VIEW;

var _game_manager : GameManager = null;
var _adv_manager : AdventurerManager = null;

func _ready():
	_game_manager = get_node("/root/Root/Game");
	_adv_manager = get_node("/root/Root/Adventurers");

func _process(delta):
	var adventurers = _adv_manager.recruited_adv();
	if adventurers.size() > 1:
		adventurers.sort_custom(func (a,b): return a.adv_name()[0] >= b.adv_name()[0]);

	no_content.visible = adventurers.size() == 0;
	adv_list.visible = adventurers.size() > 0;
	
	_populate_list(adventurers);

func _populate_list(adventurers: Array):
	#print(adventurers.map(func (adv): return adv.adv_name()))
	pass;
