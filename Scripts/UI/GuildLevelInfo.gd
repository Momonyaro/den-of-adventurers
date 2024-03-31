extends HBoxContainer

@export var level_text: Label;
@export var xp_bar: ProgressBar;

@onready var _game_manager : GameManager = get_node("/root/Root/Game");

func _process(_delta):
	if _game_manager != null:
		populate(_game_manager.guild_data);

func populate(data: GuildData):
	level_text.text = str(data.guild_level);
	xp_bar.tooltip_text = str(data.guild_xp.x, ' / ', data.guild_xp.y);
	xp_bar.value = data.guild_xp.x / float(data.guild_xp.y);
	
