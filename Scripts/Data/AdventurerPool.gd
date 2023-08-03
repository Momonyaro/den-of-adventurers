class_name AdventurerPool;

const POOL_SIZE : int = 64;

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
	_adv_pool[adv._unique_id] = adv;
	pass;

func get_adventurer(id: String) -> Adventurer:
	if _adv_pool.has(id):
		return _adv_pool[id];
	return null;

func get_defined_adv_pool() -> Array[Adventurer]:
	var pool = _adv_pool.values();
	var to_return : Array[Adventurer] = [];
	
	for adv in pool:
		if adv._defined:
			to_return.push_back(adv);
	
	return to_return;

func get_rand_adventurer(guarantee_defined: bool = false) -> Adventurer:
	var defined_pool = get_defined_adv_pool();
	var pool = defined_pool if (guarantee_defined and defined_pool.size() > 0) else _adv_pool.values();
	
	var size = pool.size();
	var rand_index = randi() % size;
	var adv = pool[rand_index];
	
	_adv_pool.erase(adv._unique_id);
	generate_adventurer(); # fill the pool back up
	
	return adv;
