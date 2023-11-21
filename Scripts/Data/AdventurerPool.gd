class_name AdventurerPool;

const POOL_SIZE : int = 32;

var _adv_pool : Dictionary = {};
var _name_pool : NamePool = null;

func _init(name_pool: NamePool):
	_name_pool = name_pool;
	
	define_adventurer("Aerithus", "Sól", Adventurer.Race.DEMI_HUMAN, Adventurer.Nationality.Blacholer, 19, 10, 2);
	define_adventurer("Monrose", "Faertag", Adventurer.Race.DEMI_HUMAN, Adventurer.Nationality.Blacholer, 19, 10, 2);
	define_adventurer("Atou", "Graeli", Adventurer.Race.HUMAN, Adventurer.Nationality.Blacholer, 21, 10, 3);
	
	for i in POOL_SIZE - _adv_pool.keys().size():
		generate_adventurer();
	pass;

func define_adventurer(given_name: String, family_name: String, race: Adventurer.Race, nationality: Adventurer.Nationality, age: int, health: int, level: int):
	_name_pool.reserve_name(given_name, family_name);
	var adv_index = _adv_pool.keys().size();
	var adv = Adventurer.new(given_name, family_name, age, health, level, race, nationality, adv_index);
	adv._defined = true;
	
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

	if bool(randi_range(0, 1)):
		adv.LOOK_hat = "HAT_MAGICIAN";
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
