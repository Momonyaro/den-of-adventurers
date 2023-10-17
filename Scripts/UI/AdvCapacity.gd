extends Label

var _game_manager: GameManager = null;
var _adv_manager: AdventurerManager = null;

func _ready():
	_game_manager = get_node("/root/Root/Game");
	_adv_manager = get_node("/root/Root/Adventurers")

func _process(delta):
	self.text = str(_adv_manager.recruited().size(), "/", _game_manager._max_adventurers, " Adv.");
