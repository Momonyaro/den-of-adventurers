class_name GuildDataContainer;

const recruit_level_table: JSON = preload("res://Resources/Guild/RecruitLevelTable.tres");
const adv_cap_table: JSON = preload("res://Resources/Guild/AdvCapTable.tres");

static func get_recruit_level_range(guild_level: int, guild_tier: int) -> Vector2i:
    var lvl_table = recruit_level_table.data;

    var lowest_allowed = lvl_table[0];
    for item in lvl_table:
        var minGuildLevel = item['minGuildLevel']
        var minGuildTier = item['minGuildTier']
        if guild_level >= minGuildLevel && minGuildLevel >= lowest_allowed['minGuildLevel'] && guild_level >= minGuildTier && minGuildTier >= lowest_allowed['minGuildTier']:
            lowest_allowed = item;
    return Vector2i(lowest_allowed['rangeMin'], lowest_allowed['rangeMax']);
