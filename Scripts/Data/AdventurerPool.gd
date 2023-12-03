class_name AdventurerPool;

const POOL_SIZE : int = 32;

var _adv_pool : Dictionary = {};
var _name_pool : NamePool = null;

func _init(name_pool: NamePool):
	_name_pool = name_pool;
	
	define_adventurer("Aerithus", "Sól", Adventurer.Race.DEMI_HUMAN, Adventurer.Nationality.Blacholer, 19, 10, 2, "Tri-Aspect Magician", "M_HAIR_0", "HAT_MAGICIAN");
	define_adventurer("Monrose", "Faertag", Adventurer.Race.DEMI_HUMAN, Adventurer.Nationality.Blacholer, 19, 10, 2, "Swordsman", "M_HAIR_0");
	define_adventurer("Atou", "Graeli", Adventurer.Race.HUMAN, Adventurer.Nationality.Blacholer, 21, 10, 3, "Ranger", "F_HAIR_0");
	
	for i in POOL_SIZE - _adv_pool.keys().size():
		generate_adventurer();
	pass;

func define_adventurer(given_name: String, family_name: String, race: Adventurer.Race, nationality: Adventurer.Nationality, age: int, health: int, level: int, adv_class: String, hair_option: String = "", hat_option: String = ""):
	_name_pool.reserve_name(given_name, family_name);
	var adv_index = _adv_pool.keys().size();
	var adv = Adventurer.new(given_name, family_name, age, health, level, race, nationality, adv_index);
	adv._class = adv_class;
	adv._defined = true;
	adv.LOOK_hair = hair_option;
	adv.LOOK_hat = hat_option;

	if adv._race == Adventurer.Race.DEMI_HUMAN:
		adv.LOOK_race = "DH_HORNS";
	
	_adv_pool[adv._unique_id] = adv;
	pass;

func generate_adventurer():
	var rand_name = _name_pool.get_new_name(Adventurer.Nationality.Blacholer);
	var rand_race = Adventurer.Race.HUMAN;
	if randi() % 3 == 1:
		rand_race = Adventurer.Race.DEMI_HUMAN;
	
	var adv_index = _adv_pool.keys().size();
	var adv = Adventurer.new(rand_name[0], rand_name[1], 20, 10, 1, rand_race, Adventurer.Nationality.Blacholer, adv_index);
	
	adv._fatigue = randf_range(0, 0.9);
	adv._xp = Vector2i(randi_range(0, 100), 200);

	if adv._race == Adventurer.Race.DEMI_HUMAN:
		adv.LOOK_race = "DH_HORNS";

	if bool(randi_range(0, 1)):
		adv.LOOK_hat = "HAT_MAGICIAN";
		
	if bool(randi_range(0, 1)):
		adv.LOOK_hair = "F_HAIR_0";
	else:
		adv.LOOK_hair = "M_HAIR_0";
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

func get_rand_adventurer(guarantee_defined: bool = false) -> Adventurer:
	var defined_pool = get_defined_adv_pool();
	var pool = defined_pool if (guarantee_defined and defined_pool.size() > 0) else _adv_pool.values();
	
	var size = pool.size();
	var rand_index = randi() % size;
	var adv = pool[rand_index];
	
	_adv_pool.erase(adv._unique_id);
	if _adv_pool.size() < POOL_SIZE:
		generate_adventurer(); # fill the pool back up
	
	return adv;
