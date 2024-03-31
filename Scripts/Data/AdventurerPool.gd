class_name AdventurerPool;

const POOL_SIZE : int = 32;

var _adv_pool : Dictionary = {};
var _name_pool : NamePool = null;

func _init(name_pool: NamePool, guild_level: int, guild_tier: int):
	_name_pool = name_pool;
	var level_range = GuildDataContainer.get_recruit_level_range(guild_level, guild_tier);
	
	define_adventurer("Aerithus", "Sól", Adventurer.Race.DEMI_HUMAN, Adventurer.Nationality.Blacholer, 19, 10, 2, "sourcerer", "MALE");
	define_adventurer("Monrose", "Faertag", Adventurer.Race.DEMI_HUMAN, Adventurer.Nationality.Vignarran, 19, 10, 2, "spellsword", "MALE");
	define_adventurer("Atou", "Graeli", Adventurer.Race.HUMAN, Adventurer.Nationality.Blacholer, 21, 10, 3, "ranger", "FEMALE");
	
	for i in POOL_SIZE - _adv_pool.keys().size():
		generate_adventurer(level_range);
	pass;

func define_adventurer(given_name: String, family_name: String, race: Adventurer.Race, nationality: Adventurer.Nationality, age: int, health: int, level: int, adv_class: String, gender: String):
	_name_pool.reserve_name(given_name, family_name);
	var adv_index = _adv_pool.keys().size();
	var adv = Adventurer.new(given_name, family_name, age, health, level, race, nationality, adv_index);
	adv._class = adv_class;
	var class_appearance = ClassDataContainer.get_class_from_id(adv_class)['appearance'];
	adv._defined = true;
	adv.LOOK_race = get_race_customization(race, nationality);
	adv.LOOK_hair = get_hair_customization(gender) if class_appearance['hairVisible'] else "";
	adv.LOOK_hat = class_appearance['hat'];
	adv.LOOK_weapon =  class_appearance['weapon'];
	
	_adv_pool[adv._unique_id] = adv;
	pass;

func generate_adventurer(level_range: Vector2i):
	var nationality = WorldDataContainer.get_rand_nationality_w();
	var gender = WorldDataContainer.get_rand_gender_w(nationality);
	var race = WorldDataContainer.get_rand_race_w(nationality);
	var rand_class = ClassDataContainer.get_rand_class_w(nationality, race);

	var rand_name = _name_pool.get_new_name(nationality, gender);
	
	var adv_index = _adv_pool.keys().size();
	var level = randi_range(level_range.x, level_range.y);
	var adv = Adventurer.new(rand_name[0], rand_name[1], 20, 10, level, race, nationality, adv_index);
	
	var class_appearance = rand_class['appearance'];
	adv.LOOK_race = get_race_customization(race, nationality);
	adv.LOOK_hair = get_hair_customization(gender) if class_appearance['hairVisible'] else "";
	adv.LOOK_hat = class_appearance['hat'];
	adv.LOOK_weapon =  class_appearance['weapon'];

	adv._fatigue = randf_range(0, .2);
	adv._xp = Vector2i(randi_range(0, 80), 100);
	adv._class = rand_class['id'];
	
	_adv_pool[adv._unique_id] = adv;
	pass;

func get_adventurer(id: String) -> Adventurer:
	if _adv_pool.has(id):
		return _adv_pool[id];
	return null;

func get_defined_adv_pool() -> Array:
	return _adv_pool.values().filter(
		func(adv: Adventurer): return adv._defined;
	);

func remove_adventurer(name_key: String):
	_name_pool.delete_reserved_name(name_key);

func get_rand_adventurer(guild_level: int, guild_tier: int, guarantee_defined: bool = false) -> Adventurer:
	var defined_pool = get_defined_adv_pool();
	var pool = defined_pool if (guarantee_defined and defined_pool.size() > 0) else _adv_pool.values();
	var level_range = GuildDataContainer.get_recruit_level_range(guild_level, guild_tier);
	
	var size = pool.size();
	var rand_index = randi() % size;
	var adv = pool[rand_index];
	
	_adv_pool.erase(adv._unique_id);
	if _adv_pool.size() < POOL_SIZE:
		generate_adventurer(level_range); # fill the pool back up
	
	return adv;

func get_race_customization(race: Adventurer.Race, nationality: Adventurer.Nationality) -> String:
	if race == Adventurer.Race.HUMAN:
		return "";

	match nationality:
		Adventurer.Nationality.Montian: return "DH_HORNS";
		Adventurer.Nationality.Vignarran: return "DH_HORNS_V";
		_: return "DH_HORNS";

func get_hair_customization(gender: String) -> String:
	match gender:
		'FEMALE': return "F_HAIR_0";
		_: return "M_HAIR_0";
