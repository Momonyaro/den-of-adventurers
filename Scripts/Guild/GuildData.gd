class_name GuildData;

var guild_name: String = "NILUTHUS";
var guildhall_tier: int = 0;
var guildhall_adv_cap: int = 4;
var guild_level: int = 1;
var guild_xp: Vector2i = Vector2i(0, 100);

func add_xp(xp: int):
	guild_xp.x += xp;
	if guild_xp.x >= guild_xp.y:
		guild_xp.x = guild_xp.y - guild_xp.x;
		guild_level += 1;

func to_dict() -> Dictionary:
	return {
		'guild_name': guild_name,
		'guildhall_tier': guildhall_tier,
		'guildhall_adv_cap': guildhall_adv_cap,
		'guild_level': guild_level,
		'guild_xp': guild_xp
	};

static func from_dict(dict: Dictionary) -> GuildData:
	var new_result = GuildData.new();
	
	new_result.guild_name = dict['guild_name'];
	new_result.guildhall_tier = dict['guildhall_tier'];
	new_result.guildhall_adv_cap = dict['guildhall_adv_cap'];
	new_result.guild_level = dict['guild_level'];
	new_result.guild_xp = SettingsManager.string_to_vector2i(str(dict['guild_xp']));

	return new_result;
