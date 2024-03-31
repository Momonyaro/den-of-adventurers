extends Label

var _game_manager: GameManager = null;

func _ready():
	_game_manager = get_node("/root/Root/Game");

func _process(_delta):
	if _game_manager != null:
		self.text = str(_game_manager.guild_data.guild_balance);
