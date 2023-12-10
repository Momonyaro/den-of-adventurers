extends HBoxContainer

@export var name_text: Label;
@export var level_text: Label;
@export var xp_bar: ProgressBar;

func populate(data: GuildData):
	name_text.text = data.guild_name;
	level_text.text = str(data.guild_level);
	xp_bar.value = data.guild_xp.x / float(data.guild_xp.y);
	
