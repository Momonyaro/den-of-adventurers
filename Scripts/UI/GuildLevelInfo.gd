extends HBoxContainer

@export var level_text: Label;
@export var xp_bar: ProgressBar;

@onready var _game_manager : GameManager = get_node("/root/Root/Game");

func _process(_delta):
	populate(_game_manager.guild_data);

func populate(data: GuildData):
	level_text.text = str(data.guild_level);
	xp_bar.value = data.guild_xp.x / float(data.guild_xp.y);
	
